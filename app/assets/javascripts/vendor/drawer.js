var drawerHolder = document.getElementById('drawer-holder');
var activeIcon = false;

createDrawer();
createIcon();

function createDrawer() {
  var drawerDiv = document.createElement('div');
  drawerDiv.id = 'drawer';
  var drawerUl = document.createElement('ul');
  drawerUl.id = 'drawer-ul';
  var drawerHeader = document.createElement('h1');
  drawerHeader.id = 'drawer-header';

  drawerHolder.appendChild(drawerDiv);
  drawerDiv.appendChild(drawerHeader);
  drawerDiv.appendChild(drawerUl);
}

function createIcon() {
  var iconDiv = document.createElement('div');
  var hamDiv  = document.createElement('div');
  iconDiv.id = 'icon';
  hamDiv.className = 'hamburger';
  drawerHolder.appendChild(iconDiv);
  iconDiv.appendChild(hamDiv);
  clickIcon();
}

function clickIcon() {
  var icon = document.getElementById('icon');
  icon.addEventListener('click', function() {
    if (!activeIcon) {
      icon.classList.add('active');
      drawer.classList.add('active');
      activeIcon = true;
    } else {
      icon.classList.remove('active');
      drawer.classList.remove('active');
      activeIcon = false;
    }
  });
}

class Drawer {
  constructor() {
    this.header = document.getElementById('drawer-header');
    this.list   = document.getElementById('drawer-ul');
    this.drawer = document.getElementById('drawer');
  }

  /* This function expects an array of objects, for example: addListItems([{href: 'yourhref.com', content: 'list title'}]); */
  addListItems(items) {
    this.header.innerHTML = 'Read them all!';
    for (var i = 0; i < items.length; i++) {
      this.list.innerHTML += '<li>';
      this.list.innerHTML += '<div class="roundedCheckbox"><input type="checkbox" value="None" onchange="toggleChecklistItem(\'' + items[i].href + '\', this.checked)" id="roundedCheckbox-' + i + '" name="check" /><label for="roundedCheckbox-' + i + '"></label></div>';
      this.list.innerHTML += '<a href="' + items[i].href + '">' + items[i].content + '</a>';
      this.list.innerHTML += '</li>';
    };
    return this;
  }
}

function toggleChecklistItem(thing, val) {
  console.log(thing, val);

  request = void 0;
  request = $.ajax({
      type: val ? 'POST' : 'DELETE',
      url: '/users/consume.json',
      dataType: 'json',
      data: {
        product: thing
      }
    });

  request.done(function(data, textStatus, jqXHR) {
    console.log('consumed');
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log(textStatus);
  });
}
