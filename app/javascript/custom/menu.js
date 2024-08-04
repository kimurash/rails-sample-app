// メニュー操作

// トグルリスナーを追加してクリックをリッスンする
// ページ読み込みイベントにリスナーを追加
document.addEventListener("turbo:load", function () {
    let account = document.querySelector("#account");
    if (account) {
        // クリックイベントにリスナーを追加
        account.addEventListener("click", function (event) {
            // デフォルトのイベントをキャンセルする
            event.preventDefault();
            let menu = document.querySelector("#dropdown-menu");
            menu.classList.toggle("active");
        });
    }
});
