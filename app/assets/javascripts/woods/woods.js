function move(story_id, button) {

  //TODO determine the target node based on the node object and button selected
  var target_node;



  request = void 0;
  request = $.ajax({
      type: 'GET',
      url: '/story/' + story_id + '/move_to?target_node=' + target_node
    });
  $('#choice-pane').addClass('hidden');
  //$('#processing').removeClass('hidden');

  request.done(function(data, textStatus, jqXHR) {
    console.log("New node retrieved.");
    console.log(data);
    //TODO replace current node with this one
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    $('#choice-pane').removeClass('hidden');
    console.log("Error occured: " + textStatus);
  });

}
