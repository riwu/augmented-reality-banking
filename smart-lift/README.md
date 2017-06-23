# iot-hackathon
* Camera to computer (take pics) 
* detects no. of ppl inside and outside lift
* Weight ‘sensor’ and surface area.
* Timer to show ‘up how long’, ‘down how long’
* LCD display ( display time) -- bring ipad to demonstrate
* skip floor if lift full
* Fewer floors= able to return to pick more people. Long run better?
* Communication between different lifts
 
* Machine learning to understand how lift is used (e.g near the top, near the bottom)
* Time of the day, morning afternoon evening different form of usage.
 
* First come first served? Or efficiency (10th floor with 2 open space would rather pick up 2 ppl at 2nd floor than 5 ppl at 3rd floor and let another lift pick up 5 ppl at 3rd floor)
 
## Extension
* Post waiting time to a cloud server. Mobile app to display waiting time of each lift so that users can plan accordingly. (Eg. Walk faster to catch the incoming lift, use elevator/stairs instead of going to the lift)
* Detect whether an individual has been in the lift for extended period of time (fainted, both lift and alarm system inside lift broke down). Set off alert to emergency services.
* LCD screen (Both inside lift and on each floor?) display the floors the lift is going to, number of pax waiting.
* Voice controlled So instead of you squeezing here and there just to press the buttons you just say ‘lift 1, level 3 please’. Then the ‘3’ button will light up.
* Is it possible to detect trolleys, baby pram, wheelchair etc...???
* Integrate shopping mall directory? So at each floor the buttons are replaced with a large lcd touchscreen. You search for the specific store you are looking for (e.g cinema at lvl 5, ntuc at B1) then when you click the store which means it will display the unit number as well as register that you are heading to that level and call for the lift. So it allows the lift to register and know that you are going to lvl 5 instead of only knowing that you are going up or down. (Cause some people come shopping mall with an agenda; to look for specific store to shop or eat at)
* I feel like if we want to be radical/innovative, cannot simply have up or down button. Have a LCD touchscreen where ppl select the floor they want to go to
* You guys think if its too much to have advertising inside lift. Since for that moment they are stucked and have nothing to do. Why not showcase stores. LCD screens installed at 4 corners.


## How to start up frontend
`google-chrome --allow-file-access-from-files --enable-logging=stderr frontend/index.html 2>javascript.json`

Result will be in `javascript.json`. Then parse it with
```python
import re
result = re.split('PARSE:(.*)", sou', str)
if len(result) > 1:
    content = result[1]
```
where `str` is from stdin
