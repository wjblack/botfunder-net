use worker::*;
use web_time::{SystemTime, UNIX_EPOCH};
use serde::Serialize;

// Following the router pattern in https://github.com/cloudflare/workers-rs#or-use-the-router
#[event(fetch)]
async fn main(req: Request, env: Env, _ctx: worker::Context) -> Result<Response> {

    // Create the main (long-running) router.
    let router = Router::new();

    router.get_async("/ping", |req, _ctx| async move {

        // Define the return structure, which will always have exactly these four elements for version 1.
        #[derive(Serialize)]
        struct Ping {
            version: u8,
            notes: String,
            ip: String,
            timestamp: u128,
            country: String,
        }

        // Create the struct with default elements.
        let mut ping = Ping {
            version: 1,
            notes: String::from("Your request's IP address and my current system time in millis are below."),
            ip: String::from("Unknown"),
            timestamp: 0,
            country: String::from("XX"),
        };

        // Try to extract the IP from Cloudflare's passed-in header.
        let cf_connecting_ip = req.headers().get("cf-connecting-ip").unwrap_or(None);
        if cf_connecting_ip != None {
            ping.ip = cf_connecting_ip.unwrap();
        }

        // Try to grab the system time.
        ping.timestamp = match SystemTime::now().duration_since(UNIX_EPOCH) {
            Ok(stamp) => stamp.as_millis(),
            Err(_error) => 0,
        };

        // Try to grab the origin country.
        let cf_country = req.headers().get("cf-ipcountry").unwrap_or(None);
        if cf_country != None {
            ping.country = cf_country.unwrap();
        }

        // Spit out the JSON version of the Ping struct.
        Response::from_json(&ping)
    })
    .run(req, env).await
}

// vim: set tabstop=4 shiftwidth=4 expandtab softtabstop=0 autoindent smarttab:
