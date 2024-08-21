$(function() {
  function updateIframeContent() {
    var iframeContent = $('#clover-iiif-iframe').contents();
    iframeContent.find(".manifest-property-title:contains('Homepage')").text('List of items');
    iframeContent.find("a:not([target])").attr('target', '_parent');
  }

  function observeIframe() {
    var iframe = $('#clover-iiif-iframe')[0];
    var iframeDocument = iframe.contentDocument || iframe.contentWindow.document;
    var observer = new MutationObserver(function(mutations) {
      updateIframeContent();
    });
    observer.observe(iframeDocument, { childList: true, subtree: true });
    updateIframeContent();
  }

  $('#clover-iiif-iframe').on('load', function() {
    observeIframe();
  });
});
