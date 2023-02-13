import pandas as pd
import numpy as np


def distance(pt1, pt2):
    """Return the distance between two points, represented as arrays"""
    return np.sqrt(sum((pt1 - pt2) ** 2))

def hrmatching(hr_xcord,hr_ycord):
    """Input current hr coordindinate postion, return hr, slider, and radius coordinates + color, luminoisty"""
    absmag=(hr_ycord/4.166)-10 #4.166 = 100/24
    temperature = (hr_xcord-100)
    ##MATCH
    pt_distances = []
    for i in dict:
        pt_dist = distance([temperature,absmag],[dict[i][1],dict[i][3]])
        pt_distances.append(pt_dist)
    mindist_val = min(pt_distances)
    mindist_index = pt_distances.index(mindist_val)

    ##OUTPUTS
    absmagmatch = dict[mindist_index][0]
    temperaturematch= dict[mindist_index][1]
    radiusmatch=dict[mindist_index][2]
    scaledradius = radiusmatch
    snap_hr_ycord = absmagmatch* hr_ycord
    snap_hr_xcord = temperaturematch/-100
    if radiusmatch<10 and radiusmatch>100:
        radiuscoords = [(80,80),(20,80),(20,20),(80,20)]
    if radiusmatch < 0.1 and radiusmatch > 10:
        radiuscoords = [(70, 70), (30, 70), (70, 30), (30, 30)]
    # etc

    if temperature<=3600 and temperature>2000:
        color = ["red"]
    elif temperature <= 5000 and temperature > 3600:
        color = ["orange"]
    elif temperature <= 6000 and temperature > 5000:
        color = ["yellow"]
    elif temperature <= 7500 and temperature > 5000:
        color = ["white_y"]
    elif temperature <= 11000 and temperature > 7500:
        color = ["white"]
    elif temperature <= 28000 and temperature > 11000:
        color = ["blue"]
    #etc

    startype = dict[mindist_index][5]
    if startype == 0:
        snap_sliderpos = 0
    elif startype == 1:
        snap_sliderpos =  20
    elif startype == 2:
        snap_sliderpos =  100
    elif startype == 3:
        snap_sliderpos =  40
    elif startype == 4:
        snap_sliderpos =  60
    elif startype == 5:
        snap_sliderpos =  80
    #etc

    return [snap_hr_xcord, snap_hr_ycord, radiuscoords, snap_sliderpos, color]

import pandas as pd
import numpy as np



dict = pd.read_csv('6_class_csv.csv')

print(dict)





