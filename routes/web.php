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
Route::group(['middleware' => ['auth']], function () {

    Route::get('/users/{id}', 'User\UserController@profile');
    Route::delete('/api/users/{id}', 'User\UserController@delete');
    Route::put('/api/users/{id}', 'User\UserController@update');
    Route::post('/api/users/{id}/photo', 'User\UserController@updatePhoto');

    //user role permissions
    Route::group(['middleware' => ['auth.user', 'not_banned'],
        'namespace' => 'User'], function () {

        Route::put('/api/chat/{channel_id}/messages', 'MessageController@create'); // add regex to this
        Route::post('/api/users/{id}/notifications', 'NotificationController@fetchNotifications');
        Route::delete('/api/notification/{id}/invite', 'NotificationController@deleteInvite');
        Route::put('/api/project/{id}/invite', 'NotificationController@acceptInvite');

        //user
        Route::prefix('users')->group(function () {
            Route::get('/{id}/projects', "UserController@projects");
            Route::get('/{id}/issues', 'IssueController@showUserIssues');
            Route::get('/{id}/calendar', 'UserController@calendar');
            Route::get('/{id}/notifications', 'NotificationController@show');
        });
        //[this]
        Route::post('/api/users/{id}/sort', 'UserController@fetchSort');

        Route::post('/api/users/{id}/projects', 'UserController@filterProjects');
        Route::post('/api/users/{id}/events', 'UserController@events');

        // Issues
        Route::get('/issues/{id}', 'IssueController@show');
        Route::delete('/api/issues/{id}', 'IssueController@delete');
        Route::post('/api/issues', 'IssueController@create');
        Route::put('/api/issues/comment', 'CommentController@store');
        Route::put('/api/issues/{id}', 'IssueController@update');
        Route::post('/api/issues/{id}/assign', 'IssueController@assign');
        Route::delete('/api/issues/{id}/assign', 'IssueController@desassign');
        Route::post('/api/issues/{id}/label', 'IssueController@label');
        Route::delete('/api/issues/{id}/label', 'IssueController@unlabel');

        // Vote
        Route::put('/api/votes', 'VoteController@store');

        // Chat
        Route::put('/api/project/{id}/chat', 'ChatController@create');
        Route::delete('/api/channels/{id}', 'ChatController@delete');

        //Project
        Route::put('/api/projects', 'ProjectController@create');
        Route::delete('/api/projects/{id}', 'ProjectController@delete');
        Route::put('/api/projects/{id}', 'ProjectController@update');
        Route::post('/api/projects/{id}/members', 'ProjectController@invite');
        Route::delete('/api/projects/{id}/members', 'ProjectController@remove');
        Route::post('/api/projects/{id}/list', 'IssueController@addList');
        Route::delete('/api/projects/{id}/list', 'IssueController@removeList');
        Route::prefix('projects')->group(function () {
            Route::get('/{id}', 'ProjectController@index');
            Route::get('/{id}/activity', 'ProjectController@activity');
            Route::get('/{id}/members', 'ProjectController@members');
            Route::get('/{id}/issuelist', 'IssueController@showList');
            Route::get('/{id}/board', 'IssueController@showBoard');
            Route::get('/{id}/chats', 'ProjectController@show');

        });

        // Events
        Route::post('/api/events', 'EventController@create');

        Route::post('/pusher/auth', 'NotificationController@authorizeUser');

    });

    // admin permissions
    Route::group(['middleware' => ['auth.admin'],
        'namespace' => 'Admin',
        'prefix' => "admin"], function () {
        Route::get('/{id}', 'AdminController@dashboard');
        Route::get('/search', 'AdminController@search');
        Route::get('/reports', 'AdminController@reports');
        Route::post('/countries', 'AdminController@fetchCountries'); /*api*/
        Route::post('/monthlyIntel', 'AdminController@fetchIntelPerMonth'); /*api */
        Route::post('/bannedUsers', 'AdminController@bannedUsers'); /*api */
        Route::post('/recentUsers', 'AdminController@recentUsers'); /*api */
    

        Route::post('/fetchProjects', 'AdminController@fetchProjects'); /*api */
        Route::post('/fetchUsers', 'AdminController@fetchUsers'); /*api */
        Route::put('/banUser/{id}', 'AdminController@banUser'); /*api */
        Route::put('/unbanUser/{id}', 'AdminController@UnbanUser'); /*api */
        Route::delete('/project/{id}', 'AdminController@deleteProject'); /*may change? */
        Route::post('/fetchNrProject', 'AdminController@fetchNrProjects');
        Route::post('/fetchNrTasks', 'AdminController@fetchNrTasks');
        Route::post('/fetchNrUsers', 'AdminController@fetchNrUsers');
        Route::post('/fetchNrReports', 'AdminController@fetchNrReports');
        Route::post('/fetchTeamBySize', 'AdminController@fetchByTeamSize');
    });

});
