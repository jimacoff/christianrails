// HACKER STEVE in... DEANHACK 5000

var internetWorking = false;

var npcs = {
  eugene: {name: "Eugene", email: "math_eugene@cobblestonecollege.biz"},
  gerald: {name: "Gerald", email: "gbrunston@cobblestonecollege.biz"}
}

var programs = {
  email:     { installed: true, icon: "envelope", link: "email-home", name: "SteveMail" },
  browser:   { installed: true, icon: "eye",      link: "browser",    name: "Browser" },
  networker: { installed: true, icon: "cloud",    link: "networker",  name: "Network Explorer" },
  console:   { installed: true, icon: "right",    link: "console",    name: "Console" }
};

var files = {
  privatekey: {owned: true, icon: "lock", link: "access-denied", name: "Steve's Private Key"},
};

var emails = {
  coffeeMachineBroken: { link: "coffeeMachineBroken", received: true, unread: true, subject: "Coffee machine's busted again", from: npcs[ 'gerald' ],
                         content: "Steve, your damn \"smart\" coffee machine is making scary noises and leaking everywhere. It's finals week -- I can't deal with this right now.\nI disconnected the modem and it'll stay locked in my room until you get it fixed.\n -Gerald" },
  internetInquiry:     { link: "internetInquiry",     received: true, unread: true, subject: "Internet is down", from: npcs[ 'eugene' ],
                         content: "Did you do something? I haven't been able to connect for 5 minutes now.\nEug'" }
}

var websites = {
  digiPerkInterface: { link: "digiPerkInterface", bookmarked: false }
}

var networks = {
  steveApartment: {
    name: "Th3 Cyb4rN0de", known: true,
    devices: {
      geraldsPC: { name: "GeraldsPC",      visible: true },
      mathbox:   { name: "mathbox-eugene", visible: true },
      digiPerk:  { name: "DigiPerk 850",   visible: true }
    }
  }
}

///////////////////////////////
///////////////////////////////

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

// os display helpers

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

function haveUnreadEmails() {
  var hasUnread = false;

  Object.keys(emails).forEach( function(email) {
    if (emails[email].unread) {
      hasUnread = true;
    }
  });

  return hasUnread;
}

function drawSteveOSProgramDirectory() {
  var directoryContainer = makeElementOfClass('div', "steveOS-directory");

  // draw each installed program
  Object.keys( programs ).forEach( function(program) {
    let theProgram = programs[program];
    if (theProgram.installed) {
      if ( theProgram.name === "SteveMail" && haveUnreadEmails() ) {
        directoryContainer.appendChild( makeIcon(theProgram.name, theProgram.icon + '-alert', theProgram.link ) );
      } else {
        directoryContainer.appendChild( makeIcon(theProgram.name, theProgram.icon, theProgram.link ) );
      }
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

// email client display helpers

function makeEmailHeader() {
  var emailHeaderContainer = makeElementOfClass('tr', "email-header-container");

  var emailSubject = makeElementOfClass('td', "email-header-subject-cell");
  var emailSubjectHeader = makeElementOfClass('strong', "email-header-subject");
  emailSubjectHeader.innerHTML = "Subject";

  var emailFrom = makeElementOfClass('td', "email-header-from-cell");
  var emailFromHeader = makeElementOfClass('strong', "email-header-from");
  emailFromHeader.innerHTML = "From";

  emailSubject.appendChild(emailSubjectHeader);
  emailFrom.appendChild(emailFromHeader);

  emailHeaderContainer.appendChild(emailSubject);
  emailHeaderContainer.appendChild(emailFrom);

  emailHeaderContainer.addEventListener("click", function(event) {
    openEmail(link);
    event.preventDefault();
  });

  return emailHeaderContainer;
}

function makeEmailPreview( subject, unread, from, link ) {
  var emailPreviewContainer = makeElementOfClass('tr', "email-preview-container");
  var stillUnread = unread ? 'strong' : 'span';

  var emailSubjectCell = makeElementOfClass('td', "email-preview-subject-cell");
  var emailSubject = makeElementOfClass(stillUnread, "email-preview-subject");
  emailSubject.innerHTML = subject;
  emailSubjectCell.appendChild(emailSubject);

  var emailFromCell = makeElementOfClass('td', "email-preview-from-cell");
  var emailFrom = makeElementOfClass(stillUnread, "email-preview-from");
  emailFrom.innerHTML = from.name;
  emailFromCell.appendChild(emailFrom);

  emailPreviewContainer.appendChild(emailSubjectCell);
  emailPreviewContainer.appendChild(emailFromCell);

  emailPreviewContainer.addEventListener("click", function(event) {
    openEmail(link);
    event.preventDefault();
  });

  return emailPreviewContainer;
}

function drawEmailClient( emailLink ) {
  var emailClientContainer = makeElementOfClass('div', "email-client-container");

  if (!emailLink) {
    // display inbox
    var emailTable = makeElementOfClass('table', "email-table")
    emailTable.appendChild( makeEmailHeader() );
    Object.keys( emails ).forEach( function(email) {
      let theEmail = emails[email];
      if (theEmail.received) {
        emailTable.appendChild( makeEmailPreview(theEmail.subject, theEmail.unread, theEmail.from, theEmail.link ) );
      }
    });
    emailClientContainer.appendChild( emailTable );
  } else {
    // display specific email
    var backButton = makeElementOfClass('img', "email-back-button");
    backButton.src = "/assets/hackersteve/icon-left.png";
    backButton.addEventListener("click", function(event) {
      followLink('email-home');
      event.preventDefault();
    });

    var emailToShow = emails[ emailLink ];

    var emailFrom = makeElementOfClass('p', "email-body-from");
    emailFrom.innerHTML = "From: " + emailToShow.from.name + " &lt;" + emailToShow.from.email + "&gt;";

    var emailSubject = makeElementOfClass('p', "email-body-subject");
    emailSubject.innerHTML = "Subject: " + emailToShow.subject;
    var emailBodyContainer = makeElementOfClass('pre', 'email-body-container');
    emailBodyContainer.innerHTML = emailToShow.content;

    emailClientContainer.appendChild( backButton );
    emailClientContainer.appendChild( emailFrom );
    emailClientContainer.appendChild( emailSubject );
    emailClientContainer.appendChild( emailBodyContainer );
  }

  attachToProgramContainer( emailClientContainer );
  attachToProgramContainer( homeButtonBar() );
}

/// network explorer display helpers

function drawNetworkExplorer() {
  var networkExplorerContainer = makeElementOfClass('div', "network-explorer-container");

  attachToProgramContainer( networkExplorerContainer );
  attachToProgramContainer( homeButtonBar() );
}

/// browser display helpers

function drawBrowser( webpage ) {
  var browserContainer = makeElementOfClass('div', "browser-container");

  if (internetWorking) {
    // TODO display home page
  } else {
    var noConnectionBox = makeElementOfClass('h3', "no-connection-box");
    noConnectionBox.innerHTML = "No internet connection"
    browserContainer.appendChild( noConnectionBox );
  }

  attachToProgramContainer( browserContainer );
  attachToProgramContainer( homeButtonBar() );
}

/// console display helpers

function drawConsole() {
  var consoleContainer = makeElementOfClass('div', "console-container");

  attachToProgramContainer( consoleContainer );
  attachToProgramContainer( homeButtonBar() );
}

/// general display helpers

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
  } else if (link === "networker") {
    drawNetworkExplorer();
  } else if (link === "browser") {
    drawBrowser();
  } else if (link === "console") {
    drawConsole();
  }
}

function openEmail( link ) {
  console.log('showing email ' + link);
  clearScreen();
  drawEmailClient( link );
  emails[link].unread = false;
}

function openWebpage( link ) {
  console.log('opening webpage ' + link);
  clearScreen();
  drawBrowser( link );
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
