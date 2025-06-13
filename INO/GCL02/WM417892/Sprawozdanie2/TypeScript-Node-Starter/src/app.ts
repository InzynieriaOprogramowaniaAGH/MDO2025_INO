import path from "path";
import dotenv from "dotenv";

// Załaduj zmienne środowiskowe przed resztą
dotenv.config({
  path: path.resolve(__dirname, "../.env.example"),
});

import express from "express";
import compression from "compression";
import session from "express-session";
import bodyParser from "body-parser";
import lusca from "lusca";
import MongoStore from "connect-mongo";
import flash from "express-flash";
import mongoose from "mongoose";
import passport from "passport";
import bluebird from "bluebird";
import { MONGODB_URI, SESSION_SECRET } from "./util/secrets";

// Kontrolery
import * as homeController from "./controllers/home";
import * as userController from "./controllers/user";
import * as apiController from "./controllers/api";
import * as contactController from "./controllers/contact";

// Passport config (Facebook itp.)
import * as passportConfig from "./config/passport";

const app = express();

// Połącz z MongoDB
mongoose.Promise = bluebird;
mongoose
  .connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ MongoDB connected"))
  .catch((err) => {
    console.error("❌ MongoDB connection error:", err);
    process.exit(1);
  });

// Konfiguracja Express
app.set("port", Number(process.env.PORT) || 3000);
app.set("views", path.join(__dirname, "../views"));
app.set("view engine", "pug");
app.use(compression());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(
  session({
    resave: true,
    saveUninitialized: true,
    secret: SESSION_SECRET,
    store: MongoStore.create({ mongoUrl: MONGODB_URI }),
  })
);
app.use(passport.initialize());
app.use(passport.session());
app.use(flash());
app.use(lusca.xframe("SAMEORIGIN"));
app.use(lusca.xssProtection(true));

// Ustaw użytkownika w locals
app.use((req, res, next) => {
  res.locals.user = req.user;
  next();
});

// Zapamiętaj returnTo
app.use((req, res, next) => {
  if (
    !req.user &&
    !["/login", "/signup"].includes(req.path) &&
    !req.path.startsWith("/auth") &&
    !req.path.includes(".")
  ) {
    req.session.returnTo = req.path;
  } else if (req.user && req.path === "/account") {
    req.session.returnTo = req.path;
  }
  next();
});

// Statyczne pliki
app.use(
  express.static(path.join(__dirname, "../public"), {
    maxAge: 31557600000,
  })
);

// Trasy
app.get("/", homeController.index);
app.get("/login", userController.getLogin);
app.post("/login", userController.postLogin);
app.get("/logout", userController.logout);
app.get("/forgot", userController.getForgot);
app.post("/forgot", userController.postForgot);
app.get("/reset/:token", userController.getReset);
app.post("/reset/:token", userController.postReset);
app.get("/signup", userController.getSignup);
app.post("/signup", userController.postSignup);
app.get("/contact", contactController.getContact);
app.post("/contact", contactController.postContact);
app.get("/account", passportConfig.isAuthenticated, userController.getAccount);
app.post(
  "/account/profile",
  passportConfig.isAuthenticated,
  userController.postUpdateProfile
);
app.post(
  "/account/password",
  passportConfig.isAuthenticated,
  userController.postUpdatePassword
);
app.post(
  "/account/delete",
  passportConfig.isAuthenticated,
  userController.postDeleteAccount
);
app.get(
  "/account/unlink/:provider",
  passportConfig.isAuthenticated,
  userController.getOauthUnlink
);

// API
app.get("/api", apiController.getApi);
app.get(
  "/api/facebook",
  passportConfig.isAuthenticated,
  passportConfig.isAuthorized,
  apiController.getFacebook
);

// OAuth Facebook
app.get(
  "/auth/facebook",
  passport.authenticate("facebook", {
    scope: ["email", "public_profile"],
  })
);
app.get(
  "/auth/facebook/callback",
  passport.authenticate("facebook", { failureRedirect: "/login" }),
  (req, res) => {
    res.redirect(req.session.returnTo || "/");
  }
);

export default app;
