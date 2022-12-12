// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

// Modules to add on your own
import { Ajax } from "./ajax";
const ajax = new Ajax("post", "/", "{}", null, null);
ajax.try();
