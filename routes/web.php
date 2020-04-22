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

Route::get('/report', 'Report');

Route::get('/', 'PageController@index');
Route::get('/contact', 'PageController@contact');
Route::get('/about', 'PageController@about');
Route::get('/authenticate', 'PageController@authenticate');

// User
Route::get('/users/{id}', 'UserController@profile');
Route::get('/users/{id}/projects', "UserController@projects");
Route::delete('/api/users/{id}', 'UserController@delete');
Route::post('/api/users/{id}', 'UserController@update');
Route::post('/api/users/{id}/photo', 'UserController@updatePhoto');

// Issues
Route::get('/issues/{id}', 'IssueController@show');
Route::get('/projects/{id}/issuelist', 'IssueController@showList');
Route::get('/projects/{id}/board', 'IssueController@showBoard');
Route::get('/users/{id}/issues', 'IssueController@showUserIssues');

// Events & Notifications
Route::get('/users/{id}/calendar', 'EventController@show');
Route::get('/users/{id}/notifications', 'NotificationController@show');

// Chat
Route::get('/chat/{id}', 'ChatController@show');

//Project
Route::get('/projects/{id}', 'ProjectController@index');
Route::get('/projects/{id}/activity', 'ProjectController@activity');
Route::get('/projects/{id}/members', 'ProjectController@members');
Route::put('/api/projects', 'ProjectController@create');
Route::delete('/api/projects/{id}', 'ProjectController@delete');

//Administrator
Route::get('/admin', 'AdminController@dashboard');
Route::get('/admin/search', 'AdminController@search');
