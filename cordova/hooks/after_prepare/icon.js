#!/usr/bin/env node
 
var filestocopy = [{
    "resources/icon/drawable-nodpi/icon.png": 
    "platforms/android/res/drawable/icon.png"
}, {
    "resources/icon/drawable-hdpi/icon.png": 
    "platforms/android/res/drawable-hdpi/icon.png"
}, {
    "resources/icon/drawable-ldpi/icon.png": 
    "platforms/android/res/drawable-ldpi/icon.png"
}, {
    "resources/icon/drawable-mdpi/icon.png": 
    "platforms/android/res/drawable-mdpi/icon.png"
}, {
    "resources/icon/drawable-xhdpi/icon.png": 
    "platforms/android/res/drawable-xhdpi/icon.png"
}, {
    "resources/icon/icon72.png": 
    "platforms/ios/AeroDoc/Resources/icons/icon-72.png"
}, {
    "resources/icon/icon.png": 
    "platforms/ios/AeroDoc/Resources/icons/icon.png"
}, {
    "resources/icon/icon114.png": 
    "platforms/ios/AeroDoc/Resources/icons/icon@2x.png"
}, {
    "resources/icon/icon144.png": 
    "platforms/ios/AeroDoc/Resources/icons/icon-72@2x.png"
}, ];
 
var fs = require('fs');
var path = require('path');
 
// no need to configure below
var rootdir = process.argv[2];
 
filestocopy.forEach(function(obj) {
    Object.keys(obj).forEach(function(key) {
        var val = obj[key];
        var srcfile = path.join(rootdir, key);
        var destfile = path.join(rootdir, val);
        var destdir = path.dirname(destfile);
        if (fs.existsSync(srcfile) && fs.existsSync(destdir)) {
            fs.createReadStream(srcfile).pipe(
               fs.createWriteStream(destfile));
        }
    });
});