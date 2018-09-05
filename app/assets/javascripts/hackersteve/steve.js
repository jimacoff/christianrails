// HACKER STEVE in... DEANHACK 5000

var currentLocation = 'programDirectory';

var npcs = {
  eugene: {name: "Eugene"},
  gerald: {name: "Gerald"}
}

var programs = {
  email:     { installed: true, icon: "envelope", link: "email-home", name: "SteveMail" },
  browser:   { installed: true, icon: "eye",      link: "browser",    name: "Browser" },
  networker: { installed: true, icon: "cloud",    link: "networker",  name: "Network Explorer" },
  console:   { installed: true, icon: "chevron",  link: "console",    name: "Console" }
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
  coffeeMachineBroken: { received: true, unread: true, subject: "Coffee machine's busted again", from: npcs[ 'gerald' ],
                         content: "Steve, the damn DigiPerk is making scary noises and leaking everywhere. It's finals week -- I can't deal with this right now. Can you fix it again? -Gerald" }
}

// ELEMENT BUILDERS

function makeElementOfClass(type, klass) {
  var element = document.createElement(type);
  element.className = klass;
  return element;
}

function attachToProgramContainer( element ) {
  programContainer = document.getElementsByClassName('program-container')[0];
  programContainer.appendChild( element );
}

///// DISPLAY HELPERS /////

function makeIcon(name, icon, link) {
  var newIcon = makeElementOfClass('span', "steveOS-icon");

  // draw picture
  var iconImage = makeElementOfClass('img', "steveOS-icon-image");
  iconImage.src = "/assets/hackersteve/icon-" + icon + ".png";

  // write title
  iconTitle = makeElementOfClass('p', "steveOS-icon-title");
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
  var directoryContainer = makeElementOfClass('div', "steveOS-directory");

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
  var directoryContainer = makeElementOfClass('div', "steveOS-directory");

  Object.keys( files ).forEach( function(file) {
    let theFile = files[file];
    if (theFile.owned) {
      directoryContainer.appendChild( makeIcon(theFile.name, theFile.icon, theFile.link ) );
    }
  });

  attachToProgramContainer( directoryContainer );
  attachToProgramContainer( homeButtonBar() );
}

function makeEmailPreview( subject, unread, from ) {
  var emailPreviewContainer = makeElementOfClass('div', "email-preview-container");
  var emailSubject = makeElementOfClass('span', "email-preview-subject");
  emailSubject.innerHTML = subject;
  var emailFrom = makeElementOfClass('span', "email-preview-from");
  emailFrom.innerHTML = from.name;

  emailPreviewContainer.appendChild(emailSubject);
  emailPreviewContainer.appendChild(emailFrom);

  return emailPreviewContainer;
}

function drawEmailClient() {
  var emailClientContainer = makeElementOfClass('div', "email-client-container");

  Object.keys( emails ).forEach( function(email) {
    let theEmail = emails[email];
    if (theEmail.received) {
      emailClientContainer.appendChild( makeEmailPreview(theEmail.subject, theEmail.unread, theEmail.from ) );
    }
  });

  attachToProgramContainer( emailClientContainer );
  attachToProgramContainer( homeButtonBar() );
}

// wipe the whole program container, because it's that kind of OS
function clearScreen() {
  programContainer = document.getElementsByClassName('program-container')[0];
  while (programContainer.hasChildNodes()) {
    programContainer.removeChild(programContainer.lastChild);
  }
}

function homeButtonBar() {
  var homeButtonContainer = makeElementOfClass('div', "home-button-container");
  var homeButton = makeElementOfClass('span', "steveOS-icon");
  var homeIconImage = makeElementOfClass('img', "steveOS-icon-image");
  homeIconImage.src = "/assets/hackersteve/icon-home.png";

  homeIconImage.addEventListener("click", function(event) {
    followLink('home');
    event.preventDefault();
  });

  homeButton.appendChild(homeIconImage);
  homeButtonContainer.appendChild(homeButton);

  return homeButtonContainer;
}

function getRidOfParentPanel() {
  $('.hackersteve-container').parent().removeClass("panel");
}

///// NAVIGATION HELPERS /////

function followLink( link ) {
  console.log('following link to ' + link);
  clearScreen();

  if (link === "fileDirectory") {
    drawSteveOSFileDirectory();
  } else if (link === "home") {
    drawSteveOSProgramDirectory();
  } else if (link === "email-home") {
    drawEmailClient();
  }
}

///// INITIALIZERS /////

function startNewGame() {
  $('.hackersteve-titlescreen').hide();
  getRidOfParentPanel();
  drawSteveOSProgramDirectory();
  $('.steveos-container').fadeIn();
}

// initialize the game
$(document).ready(function() {
});
