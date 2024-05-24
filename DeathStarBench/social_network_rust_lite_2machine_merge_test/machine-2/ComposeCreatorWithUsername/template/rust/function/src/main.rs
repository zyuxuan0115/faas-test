use serde::{Deserialize, Serialize};
use OpenFaaSRPC::{make_rpc, get_arg_from_caller, send_return_value_to_caller,*};
use DbInterface::*;
use std::{collections::HashMap, time::{Duration, Instant}};
use memcache::Client as memcached_client;
use redis::{Commands, RedisResult};

fn main() {
  let input: String = get_arg_from_caller();
//  let now = Instant::now();
  let mut username = String::from(&input[..]);
  username.push_str(":user_id");

  let memcache_uri = get_memcached_uri();
  let memcache_client = memcache::connect(&memcache_uri[..]).unwrap();  
 
  let result:Option<i64> = memcache_client.get(&username[..]).unwrap();

  let mut user_id: i64 = -1;
  let mut memcache_has_username: bool = false;
  match result {
    Some(x) => {
      user_id = x;
      memcache_has_username = true;
    },
    None => (),
  } 

  if memcache_has_username == false {
    let redis_uri = get_redis_rw_uri();
    let redis_client = redis::Client::open(&redis_uri[..]).unwrap();
    let mut con = redis_client.get_connection().unwrap();
   
    let mut real_username = String::from("user:");
    real_username.push_str(&input[..]);
  
    let redis_result: RedisResult<i64> = con.hget(&real_username[..],"user_id");

    match redis_result {
      Ok(x) => {
        user_id = x;
      },
      RedisError => {
        println!("User: {} doesn't exist in MongoDB", username);
        panic!("User: {} doesn't exist in MongoDB", username);
      },
    }
  }
  let new_creator = Creator {
      user_id: user_id,
      username: username,
  };

  if memcache_has_username == false {
    let mut username = String::from(&new_creator.username[..]);
    username.push_str(":user_id");
    memcache_client.set(&username[..], new_creator.user_id, 0).unwrap();
  }
  let serialized = serde_json::to_string(&new_creator).unwrap();
//  let new_now =  Instant::now();
//  println!("{:?}", new_now.duration_since(now));
  send_return_value_to_caller(serialized);
}

