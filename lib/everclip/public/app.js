$(function() {
  var currentIndex = 0;
  var scrollOffset = -100;
  var listMode = false;

  var changeListMode = function(bool) {
    listMode = bool;
    if (listMode) {
      closeAllClips();
    } else {
      openAllClips();
    }
  };

  var targetLi = function(index) {
    return $($('#clips li')[index]);
  };

  var toggleClip = function(index) {
    var target = targetLi(index);
    $('.text', target).toggle();
    $.scrollTo(target, {offset: {left: 0, top: scrollOffset}});
  };

  var toggleAllClips = function() {
    if ($('.text:hidden').length > 0) {
      openAllClips();
    } else {
      closeAllClips();
    }
    $.scrollTo(targetLi(currentIndex), {offset: {top: scrollOffset}});
  };

  var openAllClips = function() {
    $('.text:hidden').show();
  };

  var closeAllClips = function(index) {
    $('.text:visible').hide();
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
    if (e.keyCode == 74) { // 'j'
      moveTo(currentIndex + 1);
    }
    if (e.keyCode == 75) { // 'k'
      moveTo(currentIndex - 1);
    }

    if (e.keyCode == 79) { // 'o'
      if (e.shiftKey) {
        toggleAllClips();
      } else {
        toggleClip(currentIndex);
      }
    }
  });

  moveTo(0);
});
