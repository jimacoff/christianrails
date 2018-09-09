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
      geraldsPC: { link: "geraldsPC", identifier: "GeraldsPC",      visible: true, address: "192.168.1.10" },
      mathbox:   { link: "mathbox",   identifier: "mathbox-eugene", visible: true, address: "192.168.1.7"  },
      digiPerk:  { link: "digiPerk",  identifier: "DigiPerk-850",   visible: true, address: "192.168.1.13" }
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

  return emailHeaderContainer;
}

function makeEmailPreview( email ) {
  var emailPreviewContainer = makeElementOfClass('tr', "email-preview-container");
  var stillUnread = email.unread ? 'strong' : 'span';

  var emailSubjectCell = makeElementOfClass('td', "email-preview-subject-cell");
  var emailSubject = makeElementOfClass(stillUnread, "email-preview-subject");
  emailSubject.innerHTML = email.subject;
  emailSubjectCell.appendChild(emailSubject);

  var emailFromCell = makeElementOfClass('td', "email-preview-from-cell");
  var emailFrom = makeElementOfClass(stillUnread, "email-preview-from");
  emailFrom.innerHTML = email.from.name;
  emailFromCell.appendChild(emailFrom);

  emailPreviewContainer.appendChild(emailSubjectCell);
  emailPreviewContainer.appendChild(emailFromCell);

  emailPreviewContainer.addEventListener("click", function(event) {
    openEmail( email.link );
    event.preventDefault();
  });

  return emailPreviewContainer;
}

function drawEmailClient( emailLink ) {
  var emailClientContainer = makeElementOfClass('div', "email-client-container");

  if (!emailLink) {
    // display inbox
    var emailTable = makeElementOfClass('table', "email-table");
    emailTable.appendChild( makeEmailHeader() );
    Object.keys( emails ).forEach( function(email) {
      let theEmail = emails[email];
      if (theEmail.received) {
        emailTable.appendChild( makeEmailPreview( theEmail ) );
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

function makeNetworkerHeader() {
  var networkerHeaderContainer = makeElementOfClass('tr', "network-header-container");

  var networkPlaceNameCell = makeElementOfClass('td', "network-header-identifier-cell");
  var networkPlaceNameText = makeElementOfClass('strong', "network-header-identifier");
  networkPlaceNameText.innerHTML = "Network Identifier";

  var networkPlaceAddressCell = makeElementOfClass('td', "network-header-address-cell");
  var networkPlaceAddressText = makeElementOfClass('strong', "network-header-address");
  networkPlaceAddressText.innerHTML = "Address";

  networkPlaceNameCell.appendChild(networkPlaceNameText);
  networkPlaceAddressCell.appendChild(networkPlaceAddressText);

  networkerHeaderContainer.appendChild(networkPlaceNameCell);
  networkerHeaderContainer.appendChild(networkPlaceAddressCell);

  return networkerHeaderContainer;
}

function makeNetworkPlacePreview( networkPlace ) {
  var networkPlacePreviewContainer = makeElementOfClass('tr', "network-place-preview-container");

  var networkPlaceIdentifierCell = makeElementOfClass('td', "network-place-preview-identifier-cell");
  var networkPlaceIdentifierText = makeElementOfClass('p', "network-place-preview-identifier");
  networkPlaceIdentifierText.innerHTML = networkPlace.identifier;
  networkPlaceIdentifierCell.appendChild(networkPlaceIdentifierText);

  var networkPlaceAddressCell = makeElementOfClass('td', "network-place-preview-address-cell");
  var networkPlaceAddressText = makeElementOfClass('p', "network-place-preview-address");
  networkPlaceAddressText.innerHTML = networkPlace.address;
  networkPlaceAddressCell.appendChild(networkPlaceAddressText);

  networkPlacePreviewContainer.appendChild(networkPlaceIdentifierCell);
  networkPlacePreviewContainer.appendChild(networkPlaceAddressCell);

  networkPlacePreviewContainer.addEventListener("click", function(event) {
    openNetworkPlace( networkPlace.link );
    event.preventDefault();
  });

  return networkPlacePreviewContainer;
}

function drawNetworkExplorer( network ) {
  var networkExplorerContainer = makeElementOfClass('div', "network-explorer-container");
  var networkPlacesTable = makeElementOfClass('table', "network-places-table");

  var currentNetwork = network || 'steveApartment';
  var theCurrentNetwork = networks[ currentNetwork ];

  networkPlacesTable.appendChild( makeNetworkerHeader() );

  Object.keys( networks[ currentNetwork ].devices ).forEach( function(device) {
    let theNetworkPlace = theCurrentNetwork.devices[device];
    if (theNetworkPlace.visible) {
      networkPlacesTable.appendChild( makeNetworkPlacePreview( theNetworkPlace ) );
    }
  });
  networkExplorerContainer.appendChild( networkPlacesTable );

  attachToProgramContainer( networkExplorerContainer );
  attachToProgramContainer( homeButtonBar() );
}

function drawCoffeeInterface() {
  var coffeeContainer = makeElementOfClass('div', "coffee-container");

  var digiperkHeader = makeElementOfClass('h1', "coffee-header");
  digiperkHeader.innerHTML = "DigiPerk 850"

  coffeeContainer.appendChild( digiperkHeader );

  attachToProgramContainer( coffeeContainer );
  attachToProgramContainer( homeButtonBar() );
}

function drawPCAuthInterface( device ) {
  var authContainer = makeElementOfClass('div', "auth-container");

  var authHeader = makeElementOfClass('h1', "auth-header");
  authHeader.innerHTML = "Authorization Required"

  // TODO more of this

  authContainer.appendChild( authHeader );

  attachToProgramContainer( authContainer );
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
  clearScreen();
  drawEmailClient( link );
  emails[link].unread = false;
}

function openNetworkPlace( link ) {
  clearScreen();

  if (link === "geraldsPC") {
    drawPCAuthInterface( link );
  } else if (link === "mathbox") {
    drawPCAuthInterface( link );
  } else if (link === "digiPerk") {
    drawCoffeeInterface();
  }
}

function openWebpage( link ) {
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
