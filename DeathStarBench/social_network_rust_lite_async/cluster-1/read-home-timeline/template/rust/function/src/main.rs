use OpenFaaSRPC::{make_rpc, get_arg_from_caller, send_return_value_to_caller,*};
use DbInterface::*;
use std:: time::{SystemTime, Duration, Instant};
use redis::Commands;
use futures::executor::block_on;

#[tokio::main]
async fn main() {
  let http_client = reqwest::Client::new();
  let input: String = get_arg_from_caller();
  //let now = Instant::now();
  let mut timeline_info: ReadTimelineArgs = serde_json::from_str(&input).unwrap();

  let mut user_id_str: String = "user-timeline:".to_string(); 
  user_id_str.push_str(&(timeline_info.user_id.to_string()));

  // connect to redis
  let redis_uri = get_redis_rw_uri();
  let redis_client = redis::Client::open(&redis_uri[..]).unwrap();
  let mut con = redis_client.get_connection().unwrap();

  let res: Vec<String> = con.zrevrange(&user_id_str[..], timeline_info.start as isize, timeline_info.stop as isize).unwrap();

  let mut post_ids: Vec<i64> = res.iter().map(|x| x[..].parse::<i64>().unwrap()).collect();
  let serialized = serde_json::to_string(&post_ids).unwrap(); 

  //let new_now =  Instant::now();
  //println!("{:?}", new_now.duration_since(now));
  let future = make_rpc("read-posts", serialized, &http_client); 
  let posts = block_on(future);
  send_return_value_to_caller(posts);
}

