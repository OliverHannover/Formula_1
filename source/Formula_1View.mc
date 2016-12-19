using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as ActMonitor;


class Formula_1View extends Ui.WatchFace {


    var font1;
    var font2;
    var isAwake;
    var screenShape;
    var dndIcon;
    
    var clockTime;
  
 
  // the x coordinate for the center
    var center_x;
    // the y coordinate for the center
    var center_y;     

	//Variablen für die digitale Uhr
		var ampmStr = "am";
		var timeStr;
		var Use24hFormat;
		var dualtime = false;
		var dualtimeTZ = 0;
		var dualtimeDST = 0;
		 

    function initialize() {
        WatchFace.initialize();
        screenShape = Sys.getDeviceSettings().screenShape;      
    }
   
    
    function onLayout(dc) {
        font1 = Ui.loadResource(Rez.Fonts.id_font_digitalbig);
        font2 = Ui.loadResource(Rez.Fonts.id_font_digital);
      
    }

    // Draw the hash mark symbols on the watch-------------------------------------------------------
    
      function drawHashMarks5Minutes(dc) {
    	//thick 5-Minutes marks
    	var width = dc.getWidth();
        var height  = dc.getHeight();
		var n;      
        var alpha, r1, r2, marks, thicknes;
            
            dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
           
           // for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute
           	for (var alpha = Math.PI / 6; alpha <= 12 * Math.PI / 6; alpha += (Math.PI / 6)) { //jede 5. Minute
     
			r1 = width/2 -20; //inside
			r2 = width/2 -12; //outside
			thicknes = 0.06;
			
							
			marks =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha-thicknes),center_y-r2*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha+thicknes),center_y-r2*Math.cos(alpha+thicknes)],
						[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
					
			dc.fillPolygon(marks);     	
     	}
             
    }
     
    
    function drawHashMarks(dc) {
    
    	var width = dc.getWidth();
        var height  = dc.getHeight();
		var n;      
        var alpha, r1, r2, marks, thicknes;
            
            //outer thin minutes marks               
            dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);          
            for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute
           	//for (var alpha = Math.PI / 6; alpha <= 12 * Math.PI / 6; alpha += (Math.PI / 6)) { //jede 5. Minute
     
			r1 = width/2 -11; //inside
			r2 = width/2 -5 ; //outside
			thicknes = 0.01;
			
							
			marks =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha-thicknes),center_y-r2*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha+thicknes),center_y-r2*Math.cos(alpha+thicknes)],
						[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
					
			dc.fillPolygon(marks);     	
     	}
     		
     		//outer thin colored minutes marks 
     	    dc.setColor(App.getApp().getProperty("AkzentColor"), Gfx.COLOR_TRANSPARENT);
            //for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute
           	for (var alpha = Math.PI / 6; alpha <= 12 * Math.PI / 6; alpha += (Math.PI / 6)) { //jede 5. Minute
     
			r1 = width/2 -11; //inside
			r2 = width/2 -5 ; //outside
			thicknes = 0.01;
			
							
			marks =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha-thicknes),center_y-r2*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha+thicknes),center_y-r2*Math.cos(alpha+thicknes)],
						[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
					
			dc.fillPolygon(marks);     	
     	}
     	
     	
     	//Black breakers in the decoration border line   	
     	dc.setColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_TRANSPARENT); 
     	r1 = width/2 - 5; //inside
		r2 = width/2 + 2 ; //outside
		thicknes = 0.02;
     	         
            for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute
           	//for (var alpha = Math.PI / 6; alpha <= 12 * Math.PI / 6; alpha += (Math.PI / 6)) { //jede 5. Minute
									
			marks =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha-thicknes),center_y-r2*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha+thicknes),center_y-r2*Math.cos(alpha+thicknes)],
						[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
					
			dc.fillPolygon(marks);     	
     	}     
     	
     	
     //Marks in Battery
     	dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
     	dc.setPenWidth(1);  
            
            //center for battery
            var cent_x = width / 10 * 3.1;
     		var cent_y = height / 10 * 3.75;
     		
            var innerRad = 23;
            var outerRad = 6;   	  
                
            dc.drawLine(cent_x, cent_y + innerRad, cent_x , cent_y + innerRad + outerRad);
            dc.drawLine(cent_x - innerRad, cent_y , cent_x - innerRad - outerRad, cent_y);
            dc.drawLine(cent_x, cent_y - innerRad, cent_x , cent_y - innerRad - outerRad);	
           
        //Marks in Steps------------------------  
          
        dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
		//set center and length
		cent_x = width/2;
		cent_y = height / 10 * 2.9;		
     	r1 = 25; //inside
		r2 = 30; //outside
				
		dc.setPenWidth(1);         
            //for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute
           	//for (var alpha = Math.PI / 6; alpha <= 12 * Math.PI / 6; alpha += (Math.PI / 6)) { //jede 5. Minute
           	for (var alpha = Math.PI / 10 - Math.PI / 10; alpha <= 11 * Math.PI / 10; alpha += (Math.PI / 10)) { //10er schritte "Beginn bei 12"
			
			dc.drawLine(cent_x+r1*Math.sin(alpha),cent_y-r1*Math.cos(alpha), cent_x+r2*Math.sin(alpha),cent_y-r2*Math.cos(alpha));    	
     	} 
   	       

    } 

  // Draw hands ------------------------------------------------------------------
       function drawHands(dc) {        
          // the length of the minute hand
   		var minute_radius;
    	// the length of the hour hand
    	var hour_radius; 
    	
    	var width = dc.getWidth();
        var height  = dc.getHeight();

        // the minute hand to be 7/8 the length of the radius
        minute_radius = 7/8.0 * center_x;
        // the hour hand to be 2/3 the length of the minute hand
        hour_radius = 3/4.0 * minute_radius;
  				
		var HandsForm = (App.getApp().getProperty("HandsForm"));
		var color1 = (App.getApp().getProperty("HandsColor"));
		var color2 = 0x555555;
		var n;
		
		clockTime = Sys.getClockTime();
        var hours = clockTime.hour;        
        var minute = clockTime.min;
        
        var alpha, alpha2, alpha3,r0, r1, r2, r3, hand, hand1;

		
		//!black + dk_gray
		if (color1 == 0x000000) {
			color2 = 0x555555;
			}
		//!withe + lt_gray
		if (color1 == 0xFFFFFF) {
			color2 = 0xAAAAAA;
			}
		//!red + dk_red
		if (color1 == 0xFF0000) {
			color2 = 0xAA0000;
			}
		//!green + dk_green
		if (color1 == 0x00FF00) {
			color2 = 0x00AA00;
			}			
		//!blue + dk_blue
		if (color1 == 0x00AAFF) {
			color2 = 0x0000FF;
			}		
		//!orange + yellow
		if (color1 == 0xFF5500) {
			color2 = 0xFFAA00;
			}	
			
			
         //Driver-Hands-----------------
         //Formula 1 hands	
		if (HandsForm == 1) { 	
				// hours
				alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
				alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0); //alpha is rotate 90 degree
				r1 = -20;
				r2 = 12;
				
								
				hand =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
								[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
								[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
								
				hand1 =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
								[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
								[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)]   ];
								
								
		        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand);
				dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand1);
		            
			
				// minutes
				alpha = Math.PI/30.0*clockTime.min;
				alpha2 = Math.PI/30.0*(clockTime.min-15);
				r1 = -25;
				r2 = 12;
				hand =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
								[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
								[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
								
				hand1 =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
								[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
								[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)]   ];
								
								
		        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand);
				dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand1);
				
				//Draw Center Point
				dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
		        dc.drawCircle(width / 2, height / 2, 2);
		        
			}// End of if (HandsForm == 1)		

	//Pilot-Hands----------------------------------
	if (HandsForm == 2) {
	// hours
		alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
		alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
		r0 = -30;
		r1 = 9; //Entfernung zum rechten winkel
		r2 = 25;
		r3 = 50;

		//the center part	
		hand =        			[[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
								[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
								[center_x+r2*Math.sin(alpha+0.4),center_y-r2*Math.cos(alpha+0.4)],
								[center_x+r2*Math.sin(alpha-0.4),center_y-r2*Math.cos(alpha-0.4)], 
								[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)]	  ];
											
        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);
	
		//the target part				
		hand1 =         [[center_x+r2*Math.sin(alpha-0.33),center_y-r2*Math.cos(alpha-0.33)],
						[center_x+r3*Math.sin(alpha-0.2),center_y-r3*Math.cos(alpha-0.2)],
						[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
						[center_x+r3*Math.sin(alpha+0.2),center_y-r3*Math.cos(alpha+0.2)],
						[center_x+r2*Math.sin(alpha+0.33),center_y-r2*Math.cos(alpha+0.35)] ];		
		
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
		for (n=0; n<4; n++) {
			dc.drawLine(hand1[n][0], hand1[n][1], hand1[n+1][0], hand1[n+1][1]);
		}
		
            


		 // minutes
		alpha = Math.PI/30.0*clockTime.min;
		alpha2 = Math.PI/30.0*(clockTime.min-15);
		r0 = -30;
		r1 = 9; //Entfernung zum rechten winkel
		r2 = 25;
		r3 = 70;
		
		//the center part
		hand =        			[[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
								[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
								[center_x+r2*Math.sin(alpha+0.4),center_y-r2*Math.cos(alpha+0.4)],
								[center_x+r2*Math.sin(alpha-0.4),center_y-r2*Math.cos(alpha-0.4)], 
								[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)]	  ];
											
        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);
		
		//the target part
		hand1 =         [[center_x+r2*Math.sin(alpha-0.33),center_y-r2*Math.cos(alpha-0.33)],
						[center_x+r3*Math.sin(alpha-0.15),center_y-r3*Math.cos(alpha-0.15)],
						[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
						[center_x+r3*Math.sin(alpha+0.15),center_y-r3*Math.cos(alpha+0.15)],
						[center_x+r2*Math.sin(alpha+0.33),center_y-r2*Math.cos(alpha+0.33)] ];				
						
		
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
		for (n=0; n<4; n++) {
			dc.drawLine(hand1[n][0], hand1[n][1], hand1[n+1][0], hand1[n+1][1]);
		}
		//dc.drawLine(hand1[n][0], hand1[n][1], hand1[0][0], hand1[0][1]);
		
		
		//gray line around the cemter part
		hand1 =         [[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)],
						[center_x+r2*Math.sin(alpha-0.35),center_y-r2*Math.cos(alpha-0.35)],
						[center_x+r2*Math.sin(alpha+0.35),center_y-r2*Math.cos(alpha+0.35)],
						[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]			   ];					
						

		
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
		for (n=0; n<5; n++) {
			dc.drawLine(hand1[n][0], hand1[n][1], hand1[n+1][0], hand1[n+1][1]);
		}
		//dc.drawLine(hand1[n][0], hand1[n][1], hand1[0][0], hand1[0][1]);
		
		
		// Draw the CenterPoint
        dc.setPenWidth(1);
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        dc.fillCircle(width / 2, height / 2, 3);
        
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        dc.drawCircle(width / 2, height / 2, 3);
		}		
         
  }//End of drawHands(dc)
  
  
   function drawSecondHands(dc) {        
          // the length of the minute hand
   		var seconds_radius;
 	  	var width = dc.getWidth();
        var height  = dc.getHeight();
        
        //seconds_radius = 7/8.0 * center_x;
		seconds_radius = width / 2 ;
		
		var n;
	
		clockTime = Sys.getClockTime();
        var seconds = clockTime.sec;        
        
        var r1, r2, r3, hand;
		var alpha = Math.PI/30.0*clockTime.sec;
		var alpha2 = Math.PI/30.0*(clockTime.sec-15);
		
		//dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(2);
		
		//lines top and end
		r1 = width/2 -80; //inside
		r2 = width/2 - 10; //outside							
		dc.drawLine(center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha),center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha));
		dc.drawLine(center_x,center_y,center_x-30*Math.sin(alpha),center_y+30*Math.cos(alpha)); //linie nach hinten
		dc.setPenWidth(5);
		dc.drawLine(center_x-30*Math.sin(alpha-0.3),center_y+30*Math.cos(alpha-0.3),center_x-30*Math.sin(alpha+0.3),center_y+30*Math.cos(alpha+0.3));
		
		
		//little circle
		dc.setPenWidth(2);
		dc.setColor(App.getApp().getProperty("AkzentColor"), Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(center_x+(seconds_radius-30)*Math.sin(alpha),center_y-(seconds_radius-30)*Math.cos(alpha),5);		
		dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
		dc.drawCircle(center_x+(seconds_radius-30)*Math.sin(alpha),center_y-(seconds_radius-30)*Math.cos(alpha),5);

		//draw the target			
		r1 = width/2 - 70; //inside
		r2 = width/2 - 30 ; //outside
		var thicknes = 0.16;
 									
			hand =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
						[center_x+(seconds_radius-35)*Math.sin(alpha),center_y-(seconds_radius-35)*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
																
		dc.setColor(App.getApp().getProperty("AkzentColor"), Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(2);	
		dc.fillPolygon(hand);
		
		dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);		
		for (n=0; n<2; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
		
		//Sys.println("%%.2f='" + alpha.format("%.2f") + "'");
		
		//rectangle 
		r1 = -25;
		r2 = 5;
		r3 = width/2 - 80;
				
				hand =        	[[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)],
								[center_x+r3*Math.sin(alpha-0.15),center_y-r3*Math.cos(alpha-0.15)],
								[center_x+r3*Math.sin(alpha+0.15),center_y-r3*Math.cos(alpha+0.15)],
								[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
								
		dc.setPenWidth(2);
		for (n=0; n<3; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
		
		
		//Centerpoint
		dc.setPenWidth(2);
		dc.setColor(App.getApp().getProperty("AkzentColor"), Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(center_x,center_y,7);
		
		dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
		dc.drawCircle(center_x,center_y,7);
}
  
  
  
         
  //DigitalTime -----------------------------------------------------------
  function drawDigitalTime(dc) {
  
  		var width = dc.getWidth();
        var height  = dc.getHeight();
  		var now = Time.now();
  
 	  		
			dualtimeTZ = (App.getApp().getProperty("DualTimeTZ"));
			dualtimeDST = (App.getApp().getProperty("DualTimeDST"));
			
			clockTime = Sys.getClockTime();
	 			
			var dthour;
			var dtmin;
			var dtnow = now;
			// adjust to UTC/GMT
			dtnow = dtnow.add(new Time.Duration(-clockTime.timeZoneOffset));
			// adjust to time zone
			dtnow = dtnow.add(new Time.Duration(dualtimeTZ));
		
			if (dualtimeDST != 0) {
				// calculate Daylight Savings Time (DST)
				var dtDST;
				if (dualtimeDST == -1) {
					// Use the current dst value
					dtDST = clockTime.dst;
				} else {
					// Use the configured DST value
					dtDST = dualtimeDST; 
				}
				// adjust DST
				dtnow = dtnow.add(new Time.Duration(dtDST));
			}

			// create a time info object
			var dtinfo = Calendar.info(dtnow, Time.FORMAT_LONG);
			
			dthour = dtinfo.hour;
			dtmin = dtinfo.min;
			
			var use24hclock;
			//var ampmStr = "am";
			
			use24hclock = Sys.getDeviceSettings().is24Hour;
			if (!use24hclock) {
				if (dthour >= 12) {
					ampmStr = "pm";
				}
				if (dthour > 12) {
					dthour = dthour - 12;				
				} else if (dthour == 0) {
					dthour = 12;
					ampmStr = "am";
				}
			} else if (use24hclock) {
			ampmStr = "";
			}	
			
					
			
			if (dthour < 10) {
				timeStr = Lang.format("0$1$:", [dthour]);
			} else {
				timeStr = Lang.format("$1$:", [dthour]);
			}
			if (dtmin < 10) {
				timeStr = timeStr + Lang.format("0$1$", [dtmin]);
			} else {
				timeStr = timeStr + Lang.format("$1$", [dtmin]);
			}
  
  }//End of drawDigitalTime(dc)-------
  
  
  // Draw battery -------------------------------------------------------------------------
  	function drawBattery(dc) {
  	  	
  	  	var width = dc.getWidth();
        var height  = dc.getHeight();
  			
		dc.setColor((App.getApp().getProperty("HashmarksColor")), Gfx.COLOR_TRANSPARENT);
		var Battery = Sys.getSystemStats().battery;       
        //var BatteryStr = Lang.format("$1$", [Battery.toLong()]);
        var BatteryStr = Lang.format( "$1$", [ Battery.format ( "%2d" ) ] );
        
       	dc.drawText(width / 10 * 3.1, height / 10 * 2.9, Gfx.FONT_SMALL, BatteryStr, Gfx.TEXT_JUSTIFY_CENTER);
       	//battery sign
       	dc.drawRectangle(width / 10 * 3.1 -6, height / 10 * 4.1, 12, 7);
       	dc.fillRectangle(width / 10 * 3.1 + 6, height / 10 * 4.1 +1, 2, 5);
       
        dc.setColor((App.getApp().getProperty("AkzentColor")), Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(5);

		var segment = 0;
		var start = 286;
		var ende = 286;
		var loopend = Battery * 1.8;		
				
		for (segment = 18; segment <= loopend; segment += 18) { 

		start = start - 18;
		ende = start -14;		
		dc.drawArc(width / 10 * 3.1, height / 10 * 3.75, 27, 1, start, ende);
				
		}
		
		//dc.drawText(width / 10 * 2.9, height / 10 * 3, Gfx.FONT_SMALL, loopend, Gfx.TEXT_JUSTIFY_CENTER);	
		}
  

	//drawSteps(dc) --------------------------------------------------------------------------
	function drawSteps(dc) {
	
		var width = dc.getWidth();
        var height  = dc.getHeight();
	
		var actsteps = 0;
        var stepGoal = 0;		
		
		stepGoal = ActMonitor.getInfo().stepGoal;
		actsteps = ActMonitor.getInfo().steps;
            
        var stepsStr = Lang.format("$1$", [actsteps]);	
        
        dc.setColor((App.getApp().getProperty("HashmarksColor")), Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 10 * 1.8, Gfx.FONT_XTINY, stepGoal, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(width / 2, height / 10 * 2.5, Gfx.FONT_SMALL, stepsStr, Gfx.TEXT_JUSTIFY_CENTER);		
		
	
		dc.setPenWidth(4);
		dc.setColor((App.getApp().getProperty("AkzentColor")), Gfx.COLOR_TRANSPARENT);
		
		var stepPercent = 100 * actsteps / stepGoal;
					
		var loopend = stepPercent * 1.8;
		
		if (loopend > 180) {
			loopend = 180;
		}
		
		//dc.drawText(width / 2, height / 10 * 3.2, Gfx.FONT_XTINY, stepPercent, Gfx.TEXT_JUSTIFY_CENTER);
		
		var segment = 0;
		var start = 252;
		var ende = 252;
		 	
		 		
			for (segment = 18; segment <= loopend; segment += 18) { 
			start = start + 18;
			ende = start + 15;	
			dc.drawArc(width / 2, height / 10 * 2.9, 33, 0, start, ende);							
			}
		
	}
	
	//24h-watch ------------------------------------------------------------------------------------------
	function draw24hElement(dc) {
	
		var width = dc.getWidth();
        var height  = dc.getHeight();
	       	
       	var cent_x = width / 10 * 7.6;
		var cent_y = height / 10 * 3.6;
		//Kreis als Grundfläche
		dc.setColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(cent_x, cent_y, 18);
       	
       	//rechter Halbkreis
       	dc.setColor(App.getApp().getProperty("AkzentColor"), Gfx.COLOR_TRANSPARENT);
       	dc.setPenWidth(3);
       	var start = 240;
		var ende = 240;		
		for (var segment = 30; segment <= 180; segment += 30) { 
		start = start + 30;
		ende = start + 25;	
		dc.drawArc(cent_x, cent_y, 22, 0, start, ende);
		}  //linker Halbkreis
       	dc.setColor(App.getApp().getProperty("HashmarksColor"),Gfx.COLOR_TRANSPARENT);
       	dc.drawArc(cent_x, cent_y, 15, 1, 270, 90);
       	
       	//marks für 24h-Anzeige
       	dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
		//Zentrum und Länge setzen
		
     	var r1 = 14; //innenabstand
		var r2 = 20; //Außenabstand
				
		dc.setPenWidth(1);         
            //for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute
           	//for (var alpha = Math.PI / 6; alpha <= 12 * Math.PI / 6; alpha += (Math.PI / 6)) { //jede 5. Minute
           	for (var alpha = Math.PI / 6 - Math.PI / 6; alpha <= 6 * Math.PI / 6; alpha += (Math.PI / 6)) { //10er schritte "Beginn bei 12"
			
			dc.drawLine(cent_x+r1*Math.sin(alpha),cent_y-r1*Math.cos(alpha), cent_x+r2*Math.sin(alpha),cent_y-r2*Math.cos(alpha));    	
     	}
     	
     	// 24- hours Zeiger	
     	clockTime = Sys.getClockTime();
        var hours = clockTime.hour;        
        var minute = clockTime.min;
        var alpha = Math.PI/12*(1.0*clockTime.hour+clockTime.min/60.0);
        
     	r1 = -10; //innenabstand
		r2 = 0; //Außenabstand
		dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(2);	
		dc.drawLine(cent_x+r1*Math.sin(alpha),cent_y-r1*Math.cos(alpha), cent_x+r2*Math.sin(alpha),cent_y-r2*Math.cos(alpha));	
     	     					
								
								
		dc.setColor((App.getApp().getProperty("HandsColor")), Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(1);
			
     	r1 = -7; //innenabstand
		r2 = 19; //Außenabstand
		var thickness = 0.6;
     		
			
							
		var marks =		[[cent_x+r1*Math.sin(alpha+thickness),cent_y-r1*Math.cos(alpha+thickness)],
						[cent_x+r2*Math.sin(alpha),cent_y-r2*Math.cos(alpha)],
						[cent_x+r1*Math.sin(alpha-thickness),cent_y-r1*Math.cos(alpha-thickness)]   ];		
		dc.fillPolygon(marks);
		
		dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
		dc.drawPoint(cent_x, cent_y);
	}
	
	// Draw Altitude------------------------------
	function drawAltitude(dc) {	
		var width = dc.getWidth();
        var height  = dc.getHeight();
    
    		dc.setColor((App.getApp().getProperty("DigitalForegroundColor")), Gfx.COLOR_TRANSPARENT);
			
			var altitudeStr;
			//var highaltide = false;			
			var unknownaltitude = true;
			var actaltitude = 0;
			var actInfo;
			
			actInfo = Act.getActivityInfo();
			if (actInfo != null) {
				actaltitude = actInfo.altitude;
				if (actaltitude != null) {
					unknownaltitude = false;
					//if (actaltitude > 4000) {
					//	highaltide = true;
					//}
				} 				
			}
			var metric = Sys.getDeviceSettings().elevationUnits == Sys.UNIT_METRIC;
			var unit;
							
			if (unknownaltitude) {
				altitudeStr = Lang.format("Alt ?");
			} else {
				altitudeStr = Lang.format("$1$", [actaltitude.toLong()]);
			}
			if (metric) {
				unit = "Alt m";
			} else {
				unit = "Alt ft";
			}			
       		dc.drawText(width / 10 * 9 , height / 10 * 5.1, font2, altitudeStr, Gfx.TEXT_JUSTIFY_RIGHT);
       		//draw unit-String
			dc.drawText(width / 10 * 8.8, height / 10 * 6  , Gfx.FONT_XTINY, unit, Gfx.TEXT_JUSTIFY_RIGHT);
	
	}
	

	
	function drawDistance(dc) {
	// Draw Distance------------------------------  
    		dc.setColor((App.getApp().getProperty("DigitalForegroundColor")), Gfx.COLOR_TRANSPARENT);
    		
    		var width = dc.getWidth();
        	var height  = dc.getHeight();
			
			var distStr = 0;
			//var highaltide = false;			
			var unknownDistance = true;
			var actDistance = 0;
			var actInfo;
			var metric = Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC;
			var unit = "Dist km";
			
			actInfo = ActMonitor.getInfo();
			if (actInfo != null) {
			
				if (metric) {				
				unit = "Dist km";
				actDistance = actInfo.distance * 0.00001;
				} else {
				unit = "Dist mi";
				actDistance = actInfo.distance * 0.00001 * 0.621371;
				}
				
				//actDistance = actDistance.format("%2d");
				if (actDistance != null) {
					unknownDistance = false;
				} 				
			}
					
			if (unknownDistance) {
				distStr = Lang.format("Dst ?");
			} else {
				distStr = Lang.format("$1$", [actDistance.format("%.2f")] );
				//distStr = distStr * 0.621371;
			
			
				if (actDistance > 10) {
				distStr = Lang.format("$1$", [actDistance.format("%.2f")] );
				}
				if (actDistance >= 10) {
				distStr = Lang.format("$1$", [actDistance.format("%.1f")] );
				}
				if (actDistance >= 100) {
				distStr = Lang.format("$1$", [actDistance.format("%.0f")] );
				}
			}
					
       		dc.drawText(width / 10 * 9 , height / 10 * 5.15, font2, distStr, Gfx.TEXT_JUSTIFY_RIGHT);
       		//draw unit-String
			dc.drawText(width / 10 * 8.8, height / 10 * 6  , Gfx.FONT_XTINY, unit, Gfx.TEXT_JUSTIFY_RIGHT);	
	
	}

	//Draw Designelement "Promaster Land" ----------------------------------------------
	function drawPromasterLandDesign(dc) {
		var width = dc.getWidth();
        var height  = dc.getHeight();
		
  		//Dekoline
 		dc.setPenWidth(3);
 		dc.setColor(App.getApp().getProperty("AkzentColor"), Gfx.COLOR_TRANSPARENT);
 		dc.drawArc(width / 2 , height / 2, width / 2  - 23, 0, 180, 245);
 		dc.drawLine(width / 3  , height - 32, width / 3  , height / 3 * 2 - 4);
 		dc.drawLine(width / 3  , height / 3 * 2 - 4 , width / 3 *2 , height / 2 - 4);
 		dc.drawLine(width / 3 *2 , height / 2 - 4, width -23, height / 2 - 4 );
       
        //Designelement obere Anzeige Rahmen
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        //dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(width / 2, height / 10 * 2.9, 38);  	//mittlerer Kreis
        dc.fillCircle(width / 10 * 2.9, height / 10 * 3.8, 30);	//linker kreis
        dc.fillRoundedRectangle(width / 10 * 1.3, height / 10 * 3.5, 90, 37, 7);	//linke untere Ecke
        //dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        dc.fillPolygon([[width / 2 + 20 , 28], 
        				[width / 2 + 45, 40 ],
        				[width / 2 + 47, 54 ], 
        				[width / 2 + 20, height/ 2 -10 ],
        				[width / 2 + 5, height/ 2 ],
        				[width / 5 + 5  , 50 ],
        				[width / 2 - 20  , 28 ]    ]);
        //dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);				
        dc.fillCircle(width / 2 + 43, 48, 6);
               				
        dc.setColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(width / 10 * 3.1, height / 10 * 3.75, 29);	//kleine Anzeige			
        dc.fillCircle(width / 2, height / 10 * 2.9, 30);		//große Anzeige		
        dc.setPenWidth(1);				
       	dc.drawCircle(width / 10 * 1.6, 100, 3);  	//linker Niet
       	dc.drawCircle(width / 2 + 43, 46, 3);  	//rechter Niet
	
	}



// Handle the update event-----------------------------------------------------------------------
    function onUpdate(dc) {
        var width = dc.getWidth();
        var height  = dc.getHeight();
        var screenWidth = dc.getWidth();
        
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
        
        
        var timeFormat = "$1$:$2$";       
       	var now = Time.now();
        
  		// Clear the screen--------------------------------------------
        dc.setColor(Gfx.COLOR_TRANSPARENT, App.getApp().getProperty("BackgroundColor"));
        dc.clear();
  
  //Draw design Elements ------------------------------------------------------------------
   		//Draw Display  		
   		//Zeichnet Kreis als Hintergrund für das Display
   		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(width / 2, height / 2, width / 2 - 23);
        
        //dann wird der Kreis abgedeckt, so dass nur ein Ausschnitt zu sehen ist        
        dc.setColor(App.getApp().getProperty("BackgroundColor"),Gfx.COLOR_TRANSPARENT);      
        dc.fillPolygon([[0 , 0], [width, 0 ], [width, height / 2], [width / 3 * 2 , height / 2],
        				[width / 3 + 5 , height / 3 * 2 ], [width / 3 + 5 , height - 28 ],
        				[width , height - 28 ],[width , height],[0 , height ]    ]);
        				         
  		//Äußerer Halbkreis DEKO
 		dc.setPenWidth(10);
 		dc.setColor(App.getApp().getProperty("AkzentColor"), Gfx.COLOR_TRANSPARENT);
  		dc.drawArc(width / 2 , height / 2, width / 2, 1, 90, 0);  
  		
        //dünner Zierkreis zwischen Hashmarks
  		dc.setPenWidth(1);
  		dc.setColor(App.getApp().getProperty("HashmarksColor"),Gfx.COLOR_TRANSPARENT);
  		dc.drawCircle(width / 2 , height / 2, width / 2 - 13);      

 		//Draw Designelement "Promaster Land"
 		drawPromasterLandDesign(dc);
     
    	// Draw the hash marks ---------------------------------
        drawHashMarks5Minutes(dc);
        drawHashMarks(dc);

 		//Draw Battery
 		drawBattery(dc);		
  
    	//Draw Steps --------------------------------------
       	drawSteps(dc);	

		//24h-Anzeige
		draw24hElement(dc);
       
       
       //Digitale Anzeige-----------------------------------------
 		//Farbe für die Textanzeigen
        dc.setColor((App.getApp().getProperty("DigitalForegroundColor")), Gfx.COLOR_TRANSPARENT);           
     	// Draw the date -----------------------------------------
   		var info = Calendar.info(now, Time.FORMAT_LONG);
   		//dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        //var dateStr = Lang.format("$1$ $2$ $3 $4$", [info.day_of_week, info.day, ".", info.month ]);
        var dateStr =  Lang.format("$1$ $2$", [info.day_of_week, info.day]);        
		dc.drawText(width / 2 -28, height -50, font2, dateStr, Gfx.TEXT_JUSTIFY_LEFT);    
 
 	
 		//Draw DigitalTime---------------------------------
		 drawDigitalTime(dc);
		 //dc.drawText(width / 2 -23, height / 10 * 6.2  , Gfx.FONT_LARGE, timeStr, Gfx.TEXT_JUSTIFY_LEFT);
		 dc.drawText(width / 10 * 6, height / 10 * 6.6  , font1, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
		//draw ampm-String
		dc.drawText(width / 10 * 5.9, height / 10 * 6  , Gfx.FONT_XTINY, ampmStr, Gfx.TEXT_JUSTIFY_CENTER);
  
 	 
 	 	var DispInfo = (App.getApp().getProperty("DispInfo"));
 	  //Draw Altitude---------------------------------
	   if (DispInfo == 1) {
 	 	drawAltitude(dc);
		} 
		
		//Draw Distance---------------------------------
	  	if (DispInfo == 2) {
 	 	//drawDistanceKM(dc);
		//} 	 
		//if (DispInfo == 3) {
 	 	drawDistance(dc);
		}
		
      


      // Draw the do-not-disturb icon -------------------------------------------------------------------
     //   if (null != dndIcon && Sys.getDeviceSettings().doNotDisturb) {
     //       dc.drawBitmap( width * 0.75, height / 2 - 15, dndIcon);
      //  }
  
  
  
  
  // Draw hands ------------------------------------------------------------------         
     drawHands(dc);
     
      if (isAwake) {
     	drawSecondHands(dc);
      } 
      
         
    }
    

    function onEnterSleep() {
        isAwake = false;
        Ui.requestUpdate();
    }

    function onExitSleep() {
        isAwake = true;
    }
}
