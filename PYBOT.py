
from types import resolve_bases
import requests
import requests.auth
from requests.models import Response
import logging
import pandas as pd
from Credentials import USERNAME,PASSWORD,SECRET,CLIENT

#gettin aUTHENTICATE rEDDIT app
client_auth = requests.auth.HTTPBasicAuth(CLIENT, SECRET)
post_data = {'grant_type' : 'password', 'username':USERNAME, 'password':PASSWORD}
headers = {
    
    'User-Agent' : "      "
}

#getting token access id 
TOKEN_ACCESS_ENDOPINT = 'https://www.reddit.com/api/v1/access_token'
response = requests.post(TOKEN_ACCESS_ENDOPINT, data = post_data , headers=headers , auth=client_auth)

#print(response.status_code),print(response.reason)

if response.status_code == 200:
    token_id = response.json()['access_token']
    #print(response.json())
    #print(token_id) 


#do 
OAUTH_ENDPOINT = 'https://oauth.reddit.com/'

get_params = {
    
    'limit' : 5
    }
headers_get = {
    
    'User-Agent' : "scripty 1234todoty",
    'Authorization' : 'bearer ' + token_id
    } 
response2 = requests.get(OAUTH_ENDPOINT + '/r/AmItheAsshole/new/' , headers=headers_get, params=get_params)
#print(response2)
#print(response2.json())


print ('need key watch video i was watching')

df = pd.DataFrame({'name':[],'title':[],'selftext':[]})

#print (df)
for item in response2.json()['data']['children']:
     df =df.append({'name'     :item['data']['name'],
                    'title'    :item['data']['title'],
                    'selftext' :item['data']['selftext']},
                    ignore_index=True)


print(df)



##retrieve post text with operator...../r/subreddit/new                   listings > item_id

o
