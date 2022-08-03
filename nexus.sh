#! /bin/sh

help ()
{

echo "the way you exected script is wrong "
    echo "the script options are count, hosted and proxy"
    echo "example to run this script sh nexus-report.sh count"
    exit 137
}

if [ "$1" = "count" ]
then
echo " Total Repo Count"
curl -u admin:787898 -s -X 'GET' 'http://localhost:8081/service/rest/v1/repositories'  -H 'accept: application/json'  -H 'NX-ANTI-CSRF-TOKEN: 0.03359714373938205' | jq .[].name | wc -l
elif [ "$1" = "hosted" ]
then
echo " Repo Name :"
curl -u admin:787898 -s -X 'GET' 'http://localhost:8081/service/rest/v1/repositories'  -H 'accept: application/json'  -H 'NX-ANTI-CSRF-TOKEN: 0.03359714373938205' | jq ' .[] | select ( .type == "hosted" ) | .name ' | sed  's/"//g'

elif [ "$1" = "proxy" ]
then
echo " Repo Name , Remote URL"
curl -u admin:787898 -s -X 'GET' 'http://localhost:8081/service/rest/v1/repositories'  -H 'accept: application/json'  -H 'NX-ANTI-CSRF-TOKEN: 0.03359714373938205' | jq ' .[] | select ( .type == "proxy" ) | .name + ", " + .attributes.proxy.remoteUrl ' | sed  's/"//g'

elif [[ "$1" = "admin" && "$2" = "mrc" ]]
then
 echo "please enter maven repo name"
 read repo
 sed -i "s/REPONAME/$repo/g" maven.json
curl -u admin:787898 -s -d @maven.json -X 'POST' 'http://localhost:8081/service/rest/v1/repositories/maven/hosted' -H 'accept: application/json' -H 'Content-Type: application/json' -H 'NX-ANTI-CSRF-TOKEN: 0.03359714373938205'

   if [ $? -eq 0 ]
    then 
        echo "the repo creation succesful "
    else
        echo "repo creation failed"
    fi
 sed -i "s/$repo/REPONAME/g" maven.json 

else
help

fi

