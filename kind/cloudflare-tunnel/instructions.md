cloudflared tunnel login
cloudflared tunnel create my-tunnel
cloudflared tunnel create minio.s4v3-tunnel

copy the id 12a4efec-e30c-4f7e-ad42-e9a85dfefbdb
copy the config and change the id and the domain

Then create the CNAME or A name in Cloudflared
cloudflared tunnel route dns my-tunnel s4v3.net

Now Run the tunnel:
#cloudflared tunnel --config /path/to/your/config.yml run my-tunnel

cloudflared tunnel --config ./tunnel-template.yaml run my-tunnel
cloudflared tunnel --config ./auth.s4v3-tunnel.yaml run auth.s4v3-tunnel
cloudflared tunnel --config ./minio.s4v3-tunnel.yaml run minio.s4v3-tunnel