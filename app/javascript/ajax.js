export const getXhr = (url, success, fail) => {
  $.ajax(url, {
    type: "get",
  })
    .done((result) => {
      console.log(result);
      success(result);
    })
    .fail((result) => {
      console.log(result);
      // fail(result);
    });
};

export const postXhr = (url, data, success, fail) => {
  $.ajax(url, {
    type: "post",
    data: data,
  })
    .done((result) => {
      console.log(result);
      success(result);
    })
    .fail((result) => {
      console.log(result);
      // fail(result);
    });
};
