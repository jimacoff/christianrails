// HACKER STEVE in... DEANHACK 5000

var currentLocation = 'programDirectory';

var npcs = {
  eugene: {name: "Eugene"},
  gerald: {name: "Gerald"}
}

var programs = {
  email:     { installed: true, icon: "envelope", link: "email",     name: "SteveMail" },
  browser:   { installed: true, icon: "eye",      link: "browser",   name: "Browser" },
  networker: { installed: true, icon: "cloud",    link: "networker", name: "Network Explorer" },
  console:   { installed: true, icon: "chevron",  link: "console",   name: "Console" }
};

var files = {
  privatekey: {owned: true, icon: "lock", link: "access-denied", name: "Steve's Private Key"},
};

var interfaces = {
  programDirectory: "steveOS",
  fileDirectory:    "steveOS",
  email:            "email",
  browser:          "browser",
  networker:        "networker",
  console:          "console",
};

var emails = {
  coffeeMachineBroken: { received: true, subject: "", content: "", from: npcs[ 'gerald' ] }
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

function drawSteveOSProgramDirectory() {
  var directoryContainer = document.createElement('div');
  directoryContainer.className = "steveOS-directory";

  // draw each installed program
  Object.keys( programs ).forEach( function(program) {
    let theProgram = programs[program];
    if (theProgram.installed) {
      directoryContainer.appendChild( makeIcon(theProgram.name, theProgram.icon, theProgram.link ) );
    }
  });

  // draw icon for files folder
  directoryContainer.appendChild( makeIcon('Files', 'folder', 'fileDirectory' ) );

  attachToProgramContainer( directoryContainer );
}

function drawSteveOSFileDirectory() {
  var directoryContainer = document.createElement('div');
  directoryContainer.className = "steveOS-directory";

  Object.keys( files ).forEach( function(file) {
    let theFile = files[file];
    if (theFile.owned) {
      directoryContainer.appendChild( makeIcon(theFile.name, theFile.icon, theFile.link ) );
    }
  });

  attachToProgramContainer( directoryContainer );
  attachToProgramContainer( homeButtonBar() );
}

function attachToProgramContainer( element ) {
  programContainer = document.getElementsByClassName('program-container')[0];
  programContainer.appendChild( element );
}

// wipe the whole program container, because it's that kind of OS
function clearScreen() {
  programContainer = document.getElementsByClassName('program-container')[0];
  while (programContainer.hasChildNodes()) {
    programContainer.removeChild(programContainer.lastChild);
  }
}

function homeButtonBar() {
  var homeButtonContainer = document.createElement('div');
  homeButtonContainer.className = "home-button-container";

  var homeButton = document.createElement('span');
  homeButton.className = "steveOS-icon";

  var homeIconImage = document.createElement('img');
  homeIconImage.className = "steveOS-icon-image";
  homeIconImage.src = "/assets/hackersteve/icon-home.png";

  homeIconImage.addEventListener("click", function(event) {
    followLink('home');
    event.preventDefault();
  });

  homeButton.appendChild(homeIconImage);
  homeButtonContainer.appendChild(homeButton);

  return homeButtonContainer;
}

///// NAVIGATION HELPERS /////

function followLink( link ) {
  console.log('following link to ' + link);
  clearScreen();

  if (link === "fileDirectory") {
    drawSteveOSFileDirectory();
  } else if (link === "home") {
    drawSteveOSProgramDirectory();
  }
}

///// INITIALIZERS /////

// initialize the game
$(document).ready(function() {
  console.log('Initializing steveOS');
  drawSteveOSProgramDirectory();
});
