// discourse-sso-plugin/assets/javascripts/wechat-pay.js
document.addEventListener("DOMContentLoaded", () => {
  const payButton = document.getElementById("wechat-pay-btn");
  payButton.addEventListener("click", () => {
    wx.ready(() => {
      wx.chooseWXPay({
        timestamp: new Date().getTime(),
        success: (res) => {
          // 提交OpenID到后端
          fetch("/link_openid", {
            method: "POST",
            body: JSON.stringify({ openid: res.openid })
          }).then(() => alert("支付绑定成功！"));
        }
      });
    });
  });
});