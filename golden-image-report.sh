cat > /root/golden-image-report.sh << 'EOF'
#!/bin/bash

REPORT=/root/golden-image-report.txt

echo "===================================" > $REPORT
echo " Golden Image Assessment Report" >> $REPORT
echo "===================================" >> $REPORT
echo "" >> $REPORT

echo "===== HOST =====" >> $REPORT
hostnamectl >> $REPORT 2>/dev/null

echo "" >> $REPORT
echo "===== OS =====" >> $REPORT
cat /etc/os-release >> $REPORT

echo "" >> $REPORT
echo "===== KERNEL =====" >> $REPORT
uname -a >> $REPORT

echo "" >> $REPORT
echo "===== CPU =====" >> $REPORT
lscpu >> $REPORT

echo "" >> $REPORT
echo "===== MEMORY =====" >> $REPORT
free -h >> $REPORT

echo "" >> $REPORT
echo "===== DISK =====" >> $REPORT
df -h >> $REPORT

echo "" >> $REPORT
echo "===== NETWORK =====" >> $REPORT
ip addr >> $REPORT

echo "" >> $REPORT
echo "===== OPEN PORTS =====" >> $REPORT
ss -tulpn >> $REPORT

echo "" >> $REPORT
echo "===== FIREWALL =====" >> $REPORT
ufw status verbose >> $REPORT 2>&1

echo "" >> $REPORT
echo "===== SSH HARDENING =====" >> $REPORT
grep -E "PermitRootLogin|PasswordAuthentication|PubkeyAuthentication" \
/etc/ssh/sshd_config /etc/ssh/sshd_config.d/* 2>/dev/null >> $REPORT

echo "" >> $REPORT
echo "===== FAIL2BAN =====" >> $REPORT
fail2ban-client status >> $REPORT 2>&1

echo "" >> $REPORT
echo "===== AUDITD =====" >> $REPORT
systemctl status auditd --no-pager >> $REPORT 2>&1

echo "" >> $REPORT
echo "===== RUNNING SERVICES =====" >> $REPORT
systemctl list-units --type=service --state=running >> $REPORT

echo "" >> $REPORT
echo "===== ENABLED SERVICES =====" >> $REPORT
systemctl list-unit-files --state=enabled >> $REPORT

echo "" >> $REPORT
echo "===== DOCKER =====" >> $REPORT
docker ps -a >> $REPORT 2>&1

echo "" >> $REPORT
echo "===== DOCKER CONFIG =====" >> $REPORT
cat /etc/docker/daemon.json >> $REPORT 2>/dev/null

echo "" >> $REPORT
echo "===== LYNIS SCORE =====" >> $REPORT
grep hardening_index /var/log/lynis-report.dat >> $REPORT 2>/dev/null

echo ""
echo "Report Generated:"
echo "$REPORT"
EOF

chmod +x /root/golden-image-report.sh
/root/golden-image-report.sh
