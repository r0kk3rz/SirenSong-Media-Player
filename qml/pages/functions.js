.pragma library

function durationString(length) {
    var iMinutes = Math.floor(length / 60)
    var iSeconds = (length % 60)
    var iHours = Math.floor(length / 3600)

    var output

    if(iMinutes <= 99)
    {
        if (iMinutes.toString().length == 1)
            iMinutes = ("0" + iMinutes)

        if (iSeconds.toString().length == 1)
            iSeconds = ("0" + iSeconds)

        output = iMinutes + ":" + iSeconds
    }
    else
    {
        output = iHours + ":" + iMinutes + ":" + iSeconds
    }

    return output
}
