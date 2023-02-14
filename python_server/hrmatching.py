
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
    absmag=convert_coord_sys(hr_ycord, -100, 50, 14, -10)
    print(absmag)
    #absmag=(hr_ycord/4.166)-10 #4.166 = 100/24
    ##temperature = convert_coord_sys(hr_xcord, -100, 50, 30000, 1000)
    classifval = convert_coord_sys(hr_xcord, -100, 50, 7, 0)
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
    print(temperature)






    # print("temperature")
    # print(temperature)

    #temperature = (hr_xcord * 1000)
    ##MATCH
    pt_distances = []
    for i in range(1,240,1):
        # print("i")
        # print(i)
        if star_data.loc[i].iat[0] <= 3850:
            matchstarclassifval = 7
        if star_data.loc[i].iat[0] <= 5300 and star_data.loc[i].iat[0] > 3850:
            matchstarclassifval = 6
        if star_data.loc[i].iat[0] <= 5920 and star_data.loc[i].iat[0] > 5300:
            matchstarclassifval = 5
        if star_data.loc[i].iat[0] <= 7240 and star_data.loc[i].iat[0] > 5920:
            matchstarclassifval = 4
        if star_data.loc[i].iat[0] <= 9500 and star_data.loc[i].iat[0] > 7240:
            matchstarclassifval = 3
        if star_data.loc[i].iat[0] <= 31000 and star_data.loc[i].iat[0] > 9500:
            matchstarclassifval = 2
        if star_data.loc[i].iat[0] > 31000:
            matchstarclassifval = 1
        pt_dist = distance((classifval,absmag),(matchstarclassifval,star_data.loc[i].iat[3]))
        pt_distances.append(pt_dist)
    mindist_val = min(pt_distances)
    mindist_index = pt_distances.index(mindist_val)
    print(mindist_val)
    print(mindist_index)
    print(classifval)
    print(matchstarclassifval)
    print(absmag)
    print(star_data.loc[mindist_index].iat[3])

    ##OUTPUTS
    absmagmatch = float(star_data.loc[mindist_index].iat[3])
    #temperaturematch= float(dict.loc[mindist_index].iat[0])
    temperaturematch=temperature
    # print("TEMPERATUREMATCH")
    # print(temperaturematch)
    radiusmatch=float(star_data.loc[mindist_index].iat[2])

    #snap_hr_ycord = absmagmatch* hr_ycord
    snap_hr_ycord = convert_coord_sys(absmagmatch, 14, -10, -100, 50)
    #snap_hr_xcord = temperaturematch/-100
    snap_hr_xcord = convert_coord_sys(classifval, 7,0,-100, 50)
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
    elif radiusmatch>=100 and radiusmatch<1000:
        # print("topleftrad10")
        toprightrad = (45,45)
        topleftrad = (-45,45)
        bottomleftrad = (-45,-45)
        bottomrightrad= (45,-45)
    elif radiusmatch>= 1 and radiusmatch<100:
        # print("topleftrad0.1")
        toprightrad = (40, 40)
        topleftrad = (-40, 40)
        bottomleftrad = (-40, -40)
        bottomrightrad = (40, -40)
    elif radiusmatch>= 0.1 and radiusmatch<1:
        # print("topleftrad0.1")
        toprightrad = (35, 35)
        topleftrad = (-35, 35)
        bottomleftrad = (-35, -35)
        bottomrightrad = (35, -35)
    elif radiusmatch>= 0.01 and radiusmatch<0.1:
        # print("topleftrad0.01")
        toprightrad = (30, 30)
        topleftrad = (-30, 30)
        bottomleftrad = (-30, -30)
        bottomrightrad = (30, -30)
    elif radiusmatch >= 0.001 and radiusmatch<0.01:
        # print("topleftrad0.001")
        toprightrad = (20, 20)
        topleftrad = (-20, 20)
        bottomleftrad = (-20, -20)
        bottomrightrad = (20, -20)
    elif radiusmatch < 0.001:
        toprightrad = (10, 10)
        topleftrad = (-10, 10)
        bottomleftrad = (-10, -10)
        bottomrightrad = (10, -10)
    else:
        toprightrad = (10, 10)
        topleftrad = (-10, 10)
        bottomleftrad = (-10, -10)
        bottomrightrad = (10, -10)
    # etc
    # print("temperaturematch")
    # print(temperaturematch)
    if temperaturematch<=3600 :
        # print("colorred")
        color = (255.0, 0.0, 0.0) # red
        # print(color)
    elif temperaturematch <= 5000 and temperaturematch > 3600:
        color = (251.0,167.0,0.0) # orange
        # print(color)
    elif temperaturematch <= 6000 and temperaturematch > 5000:
        color = (255.0,253.0,105.0) # yellow
        # print(color)
    elif temperaturematch <= 7500 and temperaturematch > 5000:
        color = (254.0,255.0,238.0) # white_y? what's this?? yellowish-white
        # print(color)
    elif temperaturematch <= 11000 and temperaturematch > 7500:
        color = (255.0, 255.0, 255.0)
        print(color)
    elif temperaturematch > 11000:
        color = (150.0,220.0,255.0)  # blue
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
        snap_sliderpos =  10.0
        # print(snap_sliderpos)
    elif startype == 5:
        # print("sliderpos5")
        snap_sliderpos =  30.0
        # print(snap_sliderpos)
    #etc

    return snap_hr_cords, topleftrad, toprightrad, bottomleftrad, bottomrightrad, (80.0,snap_sliderpos), radiusmatch, color

#[(#,#),(#,#),(#,#),(#,#),(#,#),(#,#),"blue"]
#[snap to hr coordinates, top left toio position, top right toio position, bottom left toio posion, bottom right toio posion, slider toio position, raw radius value, color]



# print(dict)

#print(hrmatching(40,-90)) #low temp, high luminosity should match a red giant/super giant with big radius orange/red color

print(hrmatching(40,-90)) #high temp, low luminosity should match a white dwarf with low radius white color
