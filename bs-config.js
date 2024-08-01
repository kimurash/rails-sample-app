module.exports = {
    proxy: "localhost:3000", // Railsサーバーのアドレス
    files: [
        "app/assets/stylesheets/*.scss",
        "app/views/**/*.html.erb",
    ],
    reloadDelay: 500,
};
