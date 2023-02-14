


import pandas as pd
import numpy as np



star_data = pd.read_csv('6_class_csv.csv')


def distance(pt1, pt2):
    """Return the distance between two points"""
    # print(pt1[0])
    # print(pt1[1])
    # print(pt2[0])
    # print(pt2[1])


    return np.sqrt(((float(pt2[0]) - float(pt1[0]))**2) + ((float(pt2[1]) - float(pt1[1]))**2))

def convert_coord_sys(coord, old_sys_min, old_sys_max, new_sys_min, new_sys_max) -> float:
    """Convert a coordinate from one scale (e.g. [0, 100]) to another (e.g. [-100, 100])"""
    new_sys_range = new_sys_max - new_sys_min + 1
    old_sys_range = old_sys_max - old_sys_min + 1

    dist_from_old_lower_bound = coord - old_sys_min
    range_scale = dist_from_old_lower_bound / old_sys_range
    new_coord = new_sys_min + range_scale * new_sys_range

    return new_coord



def hrmatching(hr_xcord,hr_ycord):
    """Input current hr coordindinate postion, return hr, slider, and radius coordinates + color, luminoisty"""
    absmag=convert_coord_sys(hr_ycord, -50, 100, 14, -10)
    # print(absmag)
    #absmag=(hr_ycord/4.166)-10 #4.166 = 100/24
    ##temperature = convert_coord_sys(hr_xcord, -100, 50, 30000, 1000)
    classifval = convert_coord_sys(hr_xcord, -100, 50, 0, 7)
    # print(classifval)
    if classifval >= 6:
        temperature = 3850 #M-class
    if classifval < 6 and classifval >=5:
        temperature = 5300 #K-class
    if classifval < 5 and classifval >=4:
        temperature = 5920 #G-class
    if classifval < 4  and classifval >=3:
        temperature = 7240 #F-class
    if classifval < 3 and classifval >=2:
        temperature = 9500 #A-class
    if classifval < 2 and classifval >=1:
        temperature = 31000 #B-class
    if classifval <1:
        temperature = 41000  #O-class

    # print("temperature")
    # print(temperature)

    #temperature = (hr_xcord * 1000)
    ##MATCH
    pt_distances = []
    for i in range(1,240,1):
        # print("i")
        # print(i)
        pt_dist = distance((temperature,absmag),(star_data.loc[i].iat[0],star_data.loc[i].iat[3]))
        pt_distances.append(pt_dist)
    mindist_val = min(pt_distances)
    mindist_index = pt_distances.index(mindist_val)

    ##OUTPUTS
    absmagmatch = float(star_data.loc[mindist_index].iat[3])
    #temperaturematch= float(dict.loc[mindist_index].iat[0])
    temperaturematch=temperature
    # print("TEMPERATUREMATCH")
    # print(temperaturematch)
    radiusmatch=float(star_data.loc[mindist_index].iat[2])

    #snap_hr_ycord = absmagmatch* hr_ycord
    snap_hr_ycord = convert_coord_sys(absmagmatch, 14, -10, -50, 100)
    #snap_hr_xcord = temperaturematch/-100
    snap_hr_xcord = convert_coord_sys(classifval, 0,7,-100, 50)
    snap_hr_cords = (snap_hr_xcord,snap_hr_ycord)
    # print("absmag to y snap")
    # print(absmag)
    # print(absmagmatch)
    # print(snap_hr_ycord)
    # print("RADMATCH")
    # print(radiusmatch)
    if radiusmatch>=1000:
        # print("topleftrad100")
        toprightrad = (50,50)
        topleftrad = (-50,50)
        bottomleftrad = (-50,-50)
        bottomrightrad= (50,-50)
    if radiusmatch>=100 and radiusmatch<1000:
        # print("topleftrad10")
        toprightrad = (45,45)
        topleftrad = (-45,45)
        bottomleftrad = (-45,-45)
        bottomrightrad= (45,-45)
    if radiusmatch>= 1 and radiusmatch<100:
        # print("topleftrad0.1")
        toprightrad = (40, 40)
        topleftrad = (-40, 40)
        bottomleftrad = (-40, -40)
        bottomrightrad = (40, -40)
    if radiusmatch>= 0.001 and radiusmatch<0.01:
        # print("topleftrad0.01")
        toprightrad = (30, 30)
        topleftrad = (-30, 30)
        bottomleftrad = (-30, -30)
        bottomrightrad = (30, -30)
    if radiusmatch < 0.0001:
        # print("topleftrad0.001")
        toprightrad = (20, 20)
        topleftrad = (-20, 20)
        bottomleftrad = (-20, -20)
        bottomrightrad = (20, -20)
    # etc
    # print("temperaturematch")
    # print(temperaturematch)
    if temperaturematch<=3600 :
        # print("colorred")
        color = ["red"]
        # print(color)
    elif temperaturematch <= 5000 and temperaturematch > 3600:
        color = ["orange"]
        # print(color)
    elif temperaturematch <= 6000 and temperaturematch > 5000:
        color = ["yellow"]
        # print(color)
    elif temperaturematch <= 7500 and temperaturematch > 5000:
        color = ["white_y"]
        # print(color)
    elif temperaturematch <= 11000 and temperaturematch > 7500:
        color = ["white"]
        print(color)
    elif temperaturematch > 11000:
        color = ["blue"]
        # print(color)
    #etc

    startype = float(star_data.loc[mindist_index].iat[4])
    # print("startype")
    # print(startype)
    #slider pos goes from -50 to 50 on x_coord and currently stays at -80 on y (on the toio -100 to 100mat)
    if startype == 0:
        # print("sliderpos0")
        snap_sliderpos = -50
        # print(snap_sliderpos)
    elif startype == 1:
        # print("sliderpos1")
        snap_sliderpos =  -30
        # print(snap_sliderpos)
    elif startype == 2:
        # print("sliderpos2")
        snap_sliderpos =  50
        # print(snap_sliderpos)
    elif startype == 3:
        # print("sliderpos3")
        snap_sliderpos =  -10
        # print(snap_sliderpos)
    elif startype == 4:
        # print("sliderpos4")
        snap_sliderpos =  10
        # print(snap_sliderpos)
    elif startype == 5:
        # print("sliderpos5")
        snap_sliderpos =  30
        # print(snap_sliderpos)
    #etc

    return [snap_hr_cords, topleftrad, toprightrad, bottomleftrad, bottomrightrad, (-80,snap_sliderpos), radiusmatch, color]

#[(#,#),(#,#),(#,#),(#,#),(#,#),(#,#),"blue"]
#[snap to hr coordinates, top left toio position, top right toio position, bottom left toio posion, bottom right toio posion, slider toio position, raw radius value, color]



# print(dict)

# print(hrmatching(40,90)) #low temp, high luminosity should match a red giant/super giant with big radius orange/red color




