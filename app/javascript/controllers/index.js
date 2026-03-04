// app/javascript/controllers/index.js
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Registra explícitamente el controlador de productos
import ProductsController from "./products_controller"
application.register("products", ProductsController)