# video-to-theora
**Autoit GUI Wrapper for converting any video file to a Theora codec (.ogv) video file**

A small Autoit application which converts any video file to the Theora codec format which uses the .OGV file extension.

This utility is a GUI-Windows wrapper to a great and efficient command line tool called: [ffmpeg2theora](http://v2v.cc/~j/ffmpeg2theora/index.html), this command-line tool works really well by encapsulating all of the video conversion to Theora mechanics in a simple yet powerful command line tool.

### Why do I like the command line tool?
Because it does only one atomic task – Converts any video to Theora.

You can find lots of software out there converting any video format to any video format with hundreds of codecs supported and lots and lots of features (And lots of spyware & adware software installed onto your computer) – do you know what? I don’t need fancy features, I don’t need hundreds of codecs – I just want to convert any video file to the Theora format and I want it to be done in the best way meaning best quality while maintaining a small final OGV file!

And this is what **ffmpeg2theora** (command line tool) does – only converts Video files to the Theora format while maintaining great size vs quality ratio.

 
### But this command line tool has 2 significant downsides:

1. It is command line based meaning that many many people won’t be able to use it. (yes, not all of us are command line savvy)
2. It adds lots of features over the basic conversion usage, like cropping the video and resizing it etc. - features which most users don't need from it.
 

This is where this simple GUI wrapper comes into place, it uses the command line tool behind the scenes which means that you will get the best Theora conversion engine! while exposing to the user only the conversion functionality using a windows GUI, which means that the two major failures of the command line tool are remedied using this GUI wrapper.

How to use it?
Start it, add files to convert, choose the quality you want and click “Convert” that’s it – Keep it Simple.
