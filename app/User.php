<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

/**
 * id
 * email
 * username
 * password
 * name
 * phone_number
 * photo_path
 * is_admin
 * country_id
 * creation_date
 * is_banned
 */
class User extends Authenticatable
{
    use Notifiable;

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    protected $table = "user";

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password', 'phone_number', 'photo_path', 'username'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token' ,'is_deleted', 'is_admin', 'search'
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array
     */
    protected $casts = [
        'is_admin' => 'boolean',
        'is_deleted' => 'boolean'
    ];

    /**
     * The country of the user
     */
    public function country() {
        return $this->belongsTo(Country::class, 'country_id');
    }

    /**
     * The member status of the user
     */
    public function projectsStatus() {
        return $this->hasMany(MemberStatus::class, 'user_id'); 
    }

    /**
     * 
     */
    public function projectAuthorships() {
        return $this->hasMany(Project::class, 'project_id');
    }

    /**
     * 
     */
    public function issueAuthorships() {
        return $this->hasMany(Issue::class, 'author_id');
    }

    /**
     * 
     */
    public function completedIssue() {
        return $this->hasMany(Issue::class, 'completed_id');
    }

      /**
     * 
     */
    public function assignedIssues() {
        return $this->belongsToMany(Issue::class, 'assigned_user', 'user_id', 'issue_id');
    }

    /**
     * 
     */
    public function tags() {
        return $this->belongsToMany(Tag::class, 'user_tag', 'user_id', 'tag_id');
    }

    /**
     * 
     */
    public function comments() {
        return $this->hasMany(Comment::class, 'user_id');
    }

    /**
     * 
     */
    public function messages() {
        return $this->hasMany(Message::class, 'user_id');
    }

    public function reports() {
        $this->hasMany(Report::class, 'reports_id');
    }

    public function reported() {
        $this->hasMany(Report::class, 'reported_id');
    }


    /* fazer ligacao para os eventos e notifications e vote*/


}
