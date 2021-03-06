<?php

namespace App;

use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

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

    use SoftDeletes;

    // Don't add create and update timestamps in database.
    public $timestamps = false;

    protected $table = "user";

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password', 'phone_number', 'photo_path', 'username', 'description', 'is_admin'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token', 'is_deleted', 'is_admin', 'search',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array
     */
    protected $casts = [
        'is_admin' => 'boolean',
        'is_deleted' => 'boolean',
    ];

    /**
     * The country of the user
     */
    public function country()
    {
        return $this->hasOne(Country::class, 'id');
    }

    /**
     * The member status of the user
     */
    public function projectsStatus()
    {
        return $this->hasMany(MemberStatus::class, 'user_id');
    }

    /**
     *
     */
    public function projectAuthorships()
    {
        return $this->hasMany(Project::class, 'project_id');
    }

    /**
     *
     */
    public function issueAuthorships()
    {
        return $this->hasMany(Issue::class, 'author_id');
    }

    /**
     *
     */
    public function completedIssues()
    {
        return $this->hasMany(Issue::class, 'complete_id');
    }

    /**
     *
     */
    public function assignedIssues()
    {
        return $this->hasMany(Issue::class, 'assigned_user', 'user_id', 'issue_id');
    }

    /**
     *
     */
    public function tags()
    {
        return $this->belongsToMany(Tag::class, 'user_tag', 'user_id', 'tag_id');
    }

    /**
     *
     */
    public function comments()
    {
        return $this->hasMany(Comment::class, 'user_id');
    }

    /**
     *
     */
    public function messages()
    {
        return $this->hasMany(Message::class, 'user_id');
    }

    public function reports()
    {
        $this->hasMany(Report::class, 'reports_id');
    }

    public function reported()
    {
        $this->hasMany(Report::class, 'reported_id');
    }

    public function personalEvents()
    {
        $this->hasMany(EventPersonal::class, 'user_id');
    }

    public function votes()
    {
        return $this->hasMany(Vote::class, 'user_id');

    }

    /* fazer ligacao para os eventos e notifications e vote*/

}