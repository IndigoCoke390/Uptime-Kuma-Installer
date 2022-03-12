sudo apt install -y curl

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs npm git apache2
echo "Node version: ${node --version}"
echo "NPM version: ${npm --version}"

git clone https://github.com/louislam/uptime-kuma.git
cd uptime-kuma/

sudo ufw allow 3001/tcp
sudo ufw allow 443/tcp
sudo ufw allow 80/tcp
sudo ufw disable 
sudo ufw enable

npm run setup
sudo npm install pm2 -g
pm2 start npm --name uptime-kuma -- run start-server -- --port=3001 --hostname=127.0.0.1
pm2 status
pm2 startup
pm2 save

sudo a2enmod ssl proxy proxy_ajp proxy_wstunnel proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html
cd /etc/apache2/sites-available/
wget https://download855.mediafire.com/58gjkm7u5lqg/tesdwtvd7l3w0aw/uptime-kuma.conf
sudo a2ensite uptime-kuma
sudo apachectl configtest
