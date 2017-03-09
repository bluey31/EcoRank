import requests
import sys
import random
import json
import string
if len(sys.argv) != 2:
    print("incorrect num of arguments, should be one")
    sys.exit(1)
n = int(sys.argv[1])
h = "http://ecorank.lewiky.com/"
users = []
for i in range(1,n+1):
    username = ''.join(random.choice(string.ascii_lowercase) for i in range(10))
    data = {'username':username,'password':i,'long':random.uniform(-5,1),'lat':random.uniform(51,58)}
    print(data)
    r = requests.post(h+'users', data = data)
    if r.status_code == 200:
        users.append(json.loads(r.text))
print(users)
for user in users:
    headers = {'Authorization':'Bearer '+ user['token']}
    for j in range(random.randint(0,27)):
        data = {'day':20170228-j,'energyUsed':random.uniform(1000,10000)}
        m = requests.post(h+'users/'+str(user['userId'])+'/consumption',data = data,headers = headers)
    requests.post(h+'logout',headers=headers)