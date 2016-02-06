#gsm-simulator

This node app simulates a crowded scenario like a shop or cinema, where people
visit these places out of habit and use their phones according to the behavior
prescribed.

The app takes argument such as:

1. **population**: Number of people

2. **high,medium,low for frequency of visits**: These number are percentages. Each percentage
controls the fraction of population which will have a set behavior. For example, 32,23,45 means
that, 32% will visit the place very frequently per day, 23% will visit moderately and 45% won't visit much per day.

3. **high,medium,low for frequency of phone usage**: frequency of phone usage means the number of times the
user will use her/his phone per visit to the place.

4. **high,medium,low for stay time**: stay time is time in minutes the user spends at the place per visit.

5. **high,medium,low for crowd tolerance limit**: If the crowd at the place is higher than this limit then the user won't
visit the place.

##Install

1. Do a `git clone`
2. cd to the directory and `npm install`

##Usage

`node index.js 2 13,23,45 22,33,12 12,13,11 13,23,45`

The arguments have already been explained.

##Output

The output is gsm packets. You can receive them using socket.io client.
The channel is 'futurelabs'.
So, something like
`socket.on('futurelabs', (data)-> console.log data)`
would give you the generated gsm packets.
