#!/usr/bin/bash
AUTH=23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP
APIHOST=localhost:9999
FUNC=write-movie-info
#wsk action delete $FUNC
#sleep 5
#wsk action create $FUNC --docker zyuxuan0115/mm-$FUNC-async
curl -u $AUTH "http://$APIHOST/api/v1/namespaces/_/actions/$FUNC?blocking=true&result=true" \
-X POST -H "Content-Type: application/json" \
-d '{"movie_id":"tt1517268","title":"Barbie","plot_id":113473,"avg_rating":"8.9","num_rating":165314,"casts":[],"thumbnail_ids":[],"photo_ids":[],"video_ids":[]}'

curl -u $AUTH "http://$APIHOST/api/v1/namespaces/_/actions/$FUNC?blocking=true&result=true" \
-X POST -H "Content-Type: application/json" \
-d '{"movie_id":"tt1517268","title":"Barbie","plot_id":113473,"avg_rating":"8.9","num_rating":165314,"casts":[{"cast_id":201,"character":"Kirk Douglas","cast_info_id":12345}],"thumbnail_ids":[],"photo_ids":[],"video_ids":[]}'
 
