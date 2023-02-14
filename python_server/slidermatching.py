slidercord = (-35,80)

def slidermatching(slidercord):
    sliderx_cord = float(slidercord[0])
    slidery_cord = float (slidercord[1])
    if sliderx_cord >= -50 and sliderx_cord < -40:
        startype = 0
        toprightrad = (10, 10) #reddwarf
        topleftrad = (-10, 10)
        bottomleftrad = (-10, -10)
        bottomrightrad = (10, -10)
        snap_hr_xcord = 35
        snap_hr_ycord = 40
        snap_sliderpos = -50
        color = "red"

    elif sliderx_cord >= -40 and sliderx_cord < -20:
        startype = 1
        toprightrad = (15, 15) #brown dwarf
        topleftrad = (-15, 15)
        bottomleftrad = (-15, -15)
        bottomrightrad = (15, -15)
        snap_hr_xcord = 25
        snap_hr_ycord = 30
        snap_sliderpos = -30
        color = "red"


    elif sliderx_cord >= -20 and sliderx_cord < 0:
        startype = 3
        toprightrad = (30, 30) #main seq
        topleftrad = (-30, 30)
        bottomleftrad = (-30, -30)
        bottomrightrad = (30, -30)
        snap_hr_xcord = -25
        snap_hr_ycord = -25
        snap_sliderpos = -10
        color = "yellow"

    elif sliderx_cord >= 0 and sliderx_cord < 20:
        startype = 4
        toprightrad = (40, 40) #giant
        topleftrad = (-40, 40)
        bottomleftrad = (-40, -40)
        bottomrightrad = (40, -40)
        snap_hr_xcord = 10
        snap_hr_ycord = -60
        snap_sliderpos = 10
        color = "orange"

    elif sliderx_cord >= 20 and sliderx_cord < 40:
        startype = 5
        toprightrad = (50, 50) #red giant
        topleftrad = (-50, 50)
        bottomleftrad = (-50, -50)
        bottomrightrad = (50, -50)
        snap_hr_xcord = 15
        snap_hr_ycord = -80
        snap_sliderpos = 30
        color = "red"

    elif sliderx_cord >= 40 and sliderx_cord <= 50:
        startype = 2 #whitedwarf
        toprightrad = (20, 20)
        topleftrad = (-20, 20)
        bottomleftrad = (-20, -20)
        bottomrightrad = (20, -20)
        snap_hr_xcord = -30
        snap_hr_ycord = 10
        snap_sliderpos = 50
        color = "blue"

    snap_hr_cords = (snap_hr_xcord, snap_hr_ycord, )
    snap_sliderposcords = (snap_sliderpos,80)

    return [snap_hr_cords, topleftrad, toprightrad, bottomleftrad, bottomrightrad, snap_sliderposcords, color,]

print(slidermatching((-35,80))) #small