export const getXhr = (url, data, success, fail) => {
  $.ajax(url, {
    type: "get",
    data: data,
  })
    .done((result) => {
      console.log(result);
      success();
    })
    .fail((result) => {
      console.log(result);
      fail();
    });
};
