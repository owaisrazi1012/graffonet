
# JSONNET_PATH=grafonnet-lib \
#   jsonnet mssql.jsonnet > mssql.json
echo "Starting script for deploying to Jfrog"

files_list=$(find . -path ./grafonnet-lib -prune -o -name '*.jsonnet')

echo "Creating directory"
mkdir grafonnet

while IFS= read -r jsonnet_file;
do
  echo $jsonnet_file
  filename=$(basename -- "$jsonnet_file")
  filename="${filename%.*}"
  echo $filename
  JSONNET_PATH=grafonnet-lib \
   jsonnet $jsonnet_file > grafonnet/$filename.json
done <<< "$files_list"

tar -cvzf grafonnet.tar.gz grafonnet/

version=$(cat version.txt)
echo $version + 0.1 | bc > version.txt
version=$(cat version.txt)

#curl -u ${{ secrets.JFROG_USER }} -T grafonnet.tar.gz "https://grafanaascode.jfrog.io/artifactory/temp123-generic/grafonnet/$version/grafonnet.tar.gz"

#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
# payload="{\"dashboard\": $(jq . elk.json), \"overwrite\": true}"


# curl -X POST $BASIC_AUTH \
#   -H 'Content-Type: application/json' \
#   -d "${payload}" \
#   "http://admin:admin@localhost:3000/api/dashboards/db"



#   https://grafanaascode.jfrog.io/artifactory/temp123-generic/grafonnet/0.1.0/elk.json