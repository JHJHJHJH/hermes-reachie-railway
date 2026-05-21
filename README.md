# Reachie - Hermes Agent
A hermes agent distribution for sales outreach.

## Run local

```bash
docker build -t hermes-reachie .
docker run --rm -it --env-file .env -p 9119:9119 hermes-reachie
```

## Expose local server with ngrok

1. Install ngrok:

   ```bash
   # macOS
   brew install ngrok

   # Linux (snap)
   sudo snap install ngrok

   # Or download from https://ngrok.com/download
   ```

2. Sign up at https://dashboard.ngrok.com and grab your authtoken, then register it once:

   ```bash
   ngrok config add-authtoken <YOUR_AUTHTOKEN>
   ```

3. With the container running on port 9119, start a tunnel:

   ```bash
   ngrok http 9119
   ```

4. Copy the `https://<subdomain>.ngrok-free.app` forwarding URL from the ngrok output and use it as the webhook URL for any external service pointing at your local server.