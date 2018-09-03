// HACKER STEVE in... DEANHACK 5000

var programs = {
  email:     { installed: true, icon: "envelope", link: "email",     name: "SteveMail" },
  browser:   { installed: true, icon: "envelope", link: "browser",   name: "Browser" },
  networker: { installed: true, icon: "envelope", link: "networker", name: "Network Expolorer" },
  console:   { installed: true, icon: "envelope", link: "console",   name: "Console" }
}

///// DISPLAY HELPERS /////

function makeIcon(name, icon, link) {
  var newIcon = document.createElement('span');
  newIcon.className = "steveOS-icon";
  // draw picture
  var iconImage = document.createElement('img');
  iconImage.className = "steveOS-icon-image";
  iconImage.src = "/assets/hackersteve/icon-" + icon + ".png";

  // write title
  iconTitle = document.createElement('p');
  iconTitle.className = "steveOS-icon-title";
  iconTitle.innerHTML = name;

  // give it an onclick to the link
  newIcon.addEventListener("click", function(event) {
    followLink(link);
    event.preventDefault();
  });

  newIcon.appendChild(iconImage);
  newIcon.appendChild(iconTitle);

  return newIcon;
}

function drawSteveOS() {
  directoryContainer = document.getElementsByClassName('steveOS-directory')[0];
  // draw each installed program
  Object.keys( programs ).forEach( function(program) {
    let theProgram = programs[program];
    if (theProgram.installed) {
      directoryContainer.appendChild( makeIcon(theProgram.name, theProgram.icon, theProgram.link ) );
    }
  });

  // draw icon for files folder
  directoryContainer.appendChild( makeIcon('Files', 'envelope', 'files' ) );
}

///// NAVIGATION HELPERS /////

function followLink( link ) {
  console.log('following link to ' + link);
  // TODO

}

///// INITIALIZERS /////

// initialize the game
$(document).ready(function() {
  console.log('Initializing steveOS');
  drawSteveOS();
});
