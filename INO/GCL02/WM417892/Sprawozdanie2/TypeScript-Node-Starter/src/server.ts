import app from "./app";
import errorHandler from "errorhandler";

// Error handler w trybie development
if (process.env.NODE_ENV === "development") {
  app.use(errorHandler());
}

const PORT = Number(process.env.PORT) || 3000;
// Bindujemy na wszystkich interfejsach kontenera
const HOST = process.env.HOST || "0.0.0.0";

app.listen(PORT, HOST, () => {
  console.log(
    `➡️  App is running at http://${HOST}:${PORT} in ${
      process.env.NODE_ENV || "development"
    } mode`
  );
});

export default app;  // (opcjonalnie, do testów)
