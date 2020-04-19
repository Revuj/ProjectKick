<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
 */

/*
Route::get('/', 'Auth\LoginController@home');
// Cards
Route::get('cards', 'CardController@list');
Route::get('cards/{id}', 'CardController@show');

// API
Route::put('api/cards', 'CardController@create');
Route::delete('api/cards/{card_id}', 'CardController@delete');
Route::put('api/cards/{card_id}/', 'ItemController@create');
Route::post('api/item/{id}', 'ItemController@update');
Route::delete('api/item/{id}', 'ItemController@delete');

// Authentication

Route::get('login', 'Auth\LoginController@showLoginForm')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::get('logout', 'Auth\LoginController@logout')->name('logout');
Route::get('register', 'Auth\RegisterController@showRegistrationForm')->name('register');
Route::post('register', 'Auth\RegisterController@register');

 */

//Route::get('/', 'HomePageController');
//Route::get('/contact', 'Contact');
//Route::get('/about', 'About');

//Route::get('/report', 'Report');

Route::get('/', 'PageController@index');
Route::get('/contact', 'PageController@contact');
Route::get('/about', 'PageController@about');
Route::get('/authenticate', 'PageController@authenticate');

Route::get('/user/{id}', 'UserController@index');

// Issues
Route::get('/issues/{id}', 'IssueController@show');
Route::get('/projects/{id}/issuelist', 'IssueController@showList');
Route::get('/projects/{id}/board', 'IssueController@showBoard');
Route::get('/users/{id}/issues', 'IssueController@showUserIssues');

//Route::get('/user_dashboard', 'UserDashboardController@show');
