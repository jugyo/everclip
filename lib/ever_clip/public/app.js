$(function() {
  var currentIndex = 0;
  var scrollOffset = -100;

  var targetLi = function(index) {
    return $($('#clips li')[index]);
  }

  var openClip = function(index) {
    var target = targetLi(index);
    $('.text', target).toggle();
    $.scrollTo(target, {offset: {left: 0, top: scrollOffset}});
  };

  var moveTo = function(index) {
    if (index < 0 || index >= $('#clips li').length) {
      return;
    }

    var oldIndex = currentIndex;
    currentIndex = index;

    targetLi(oldIndex).removeClass('selected');

    var target = targetLi(currentIndex)
    target.addClass('selected');
    $.scrollTo(target, {offset: {top: scrollOffset}});
  };

  $(window).keydown(function(e){
    if (e.keyCode == 74) {        // 'j'
      moveTo(currentIndex + 1);
    } else if (e.keyCode == 75) { // 'k'
      moveTo(currentIndex - 1);
    } else if (e.keyCode == 79) { // 'o'
      openClip(currentIndex);
    }
  });

  moveTo(0);
});
