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

Route::get('/report', 'Report');

//======================= static pages ==================================

Route::group(['middleware' => ['guest']], function () {
    Route::get('/', 'PageController@index')->name('home');
    Route::get('/contact', 'PageController@contact');
    Route::get('/about', 'PageController@about');
});


//========================== authentication =============================
Auth::routes();
// ================== user and admin pages ==============================

// auth user permission
Route::group(['middleware' => ['auth']], function() {

    Route::get('users/{id}', 'User\UserController@index');

    //user role permissions
    Route::group(['middleware' => ['auth.user'], 
                  'namespace' => 'User'],  function() {
        
        //user
        Route::prefix('users')-> group (function() {
            Route::get('/{id}/projects', "UserController@projects");
            Route::get('/{id}/issues', 'IssueController@showUserIssues');
            Route::get('/{id}/calendar', 'EventController@show');
            Route::get('/{id}/notifications', 'NotificationController@show');
        });

    
        // Issues
        Route::get('/issues/{id}', 'IssueController@show');
 
    
        // Chat
        Route::get('/chat/{id}', 'ChatController@show');
    
        //Project
        Route::prefix('projects') ->group(function() {
            Route::get('/{id}', 'ProjectController@index');
            Route::get('/{id}/activity', 'ProjectController@activity');
            Route::get('/{id}/members', 'ProjectController@members');
            Route::get('/{id}/issuelist', 'IssueController@showList');
            Route::get('/{id}/board', 'IssueController@showBoard');
        });
    
    });
    
    // admin permissions
    Route::group(['middleware' => ['auth.admin'],
                  'namespace' => 'Admin',
                  'prefix' => "admin"], function(){
        Route::get('/{id}', 'AdminController@dashboard');
        Route::get('/search', 'AdminController@search');
    } );

});
