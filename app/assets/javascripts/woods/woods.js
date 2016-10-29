function move(story_id, button) {

  var target_node;

  if( current_node.linked_node ) {
    target_node = current_node['linked_node'];
  } else {
    if(button === "L") {
      target_node = current_node['left_link'];
    } else if(button === "R") {
      target_node = current_node['right_link'];
    }
  }

  if(pop_item) {
    showItemViewer();
    pop_item = false;
  }

  request = void 0;
  request = $.ajax({
      type: 'GET',
      format: 'json',
      url: '/woods/stories/' + story_id + '/move_to.json?target_node=' + target_node + "&dir=" + button
    });
  $('#choice-pane').addClass('hidden');

  request.done(function(data, textStatus, jqXHR) {
    current_node = data;
    if(current_node['item_found']) {
      item_gallery.push(current_node['item_found']);
      item_index = item_gallery.length - 1;
      pop_item = true;
      $('#score-span').html("Score: " +
        (parseInt($('#score-span').html().substr(7)) + current_node['item_found'].value).toString() );
    }
    drawNewNode();
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log("Error occured: " + textStatus);
    // TODO pop an error flash or something

    $('#choice-pane').removeClass('hidden');
  });
}

function drawNewNode() {

  $('#story-pane').html( '<p>' + current_node['node_text'] + '</p>' );
  $('#left-button').html( current_node['left_text'] );
  $('#right-button').html( current_node['right_text'] );

  if( current_node['palette'] !== undefined ) {
    paintPanel();
  }

  if( current_node['left_text'] !== '' ) {
    $('#left-button').removeClass('hidden');
    $('#right-button').removeClass('hidden');
    $('#big-button').addClass('hidden');
  } else {
    $('#left-button').addClass('hidden');
    $('#right-button').addClass('hidden');
    $('#big-button').removeClass('hidden');
  }
  $('#choice-pane').removeClass('hidden');
  scrollToAnchor();
}

function showItemViewer() {
  showItem();
  $('#go-to-store-button').removeClass('hidden');
  $('#gallery-button').addClass('hidden');
  $('#findpanel').removeClass('hidden');
  $('#nodepanel').addClass('hidden');

  if(item_gallery.length > 1) {
    $('#item-controls').removeClass('hidden');
  } else {
    $('#item-controls').addClass('hidden');
  }
  scrollToAnchor();
}

function hideItemViewer() {
  showStoryTitle();
  $('#nodepanel').removeClass('hidden');
  $('#go-to-store-button').addClass('hidden');
  $('#gallery-button').removeClass('hidden');
  $('#findpanel').addClass('hidden');
  scrollToAnchor();
}

function nextItem() {
  item_index += 1;
  if( item_index === item_gallery.length ) {
    item_index = 0;
  }
  showItem();
  scrollToAnchor();
}

function prevItem() {
  item_index -= 1;
  if( item_index === -1 ) {
    item_index = item_gallery.length - 1;
  }
  showItem();
  scrollToAnchor();
}

function scrollToAnchor() {
 $("html, body").scrollTop($('#woods-anchor').offset().top);
}

function showItem() {
  var itemDesc = "<strong>" + item_gallery[item_index]['name'] + "</strong>";

  if( item_gallery[item_index]['value'] > 0 ) {
    itemDesc += "\xa0\xa0\xa0\xa0Value: " + item_gallery[item_index]['value'].toString();
  }
  $('#imagepanel').html( "<img src='/assets/" + storyname + "/d_" + item_gallery[item_index]['value'] + ".jpg' class='df-image'>" );
  $('#item-desc').html( itemDesc + "<br/>" + item_gallery[item_index]['legend'] );
}

function showStoryTitle() {
  $('#imagepanel').html( "<img src='/assets/" + storyname + "/title.png' class='df-image'>" );
}

function paintPanel() {
  var fore = '#' + current_node['palette']['fore'],
      back = '#' + current_node['palette']['back'],
      alt  = '#' + current_node['palette']['alt'];

  $('#left-button').css('border-color', back);
  $('#right-button').css('border-color', back);

  $('.binary-button').css('background-color', fore);
  $('.binary-button').css('color', alt);
  $('#item-continue-button').css('background-color', alt);
  $('#item-continue-button').css('color', fore);

  $('#story-pane').css('color', fore);
  $('#story-pane').css("background-image", "-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, " + back + "), color-stop(100%, " + alt + "))");
  $('#story-pane').css("background-image", "-webkit-linear-gradient(top, " + back + " 0%," + alt + " 100%)");
  $('#story-pane').css("background-image", "-moz-linear-gradient(top, " + back + " 0%," + alt + " 100%)");
  $('#story-pane').css("background-image", "-o-linear-gradient(top, " + back + " 0%," + alt + " 100%)");
  $('#story-pane').css("background-image", "linear-gradient(top, " + back + " 0%," + alt + " 100%)");
}

function goToStore() {
  window.location = "/";
}
