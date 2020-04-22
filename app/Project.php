<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * ID
 * name NN
 * description
 * creation_date NN DF Now
 * finish_date CK finish_date > creation_date
 *  authorship_id -> user NN)
 */
class Project extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'project';

    /**
     * @var array
     */
    protected $fillable = ['name', 'description', 'finish_date', 'author_id'];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'search',
    ];

    /**
     * @return
     */
    public function author()
    {
        return $this->belongsTo(User::class, 'id');
    }

    /**
     * @return
     */
    public function channels()
    {
        return $this->hasMany(Channel::class, 'project_id');
    }

    /**
     * @return
     */
    public function issueLists()
    {
        return $this->hasMany(IssueList::class, 'project_id');
    }

    /**
     * Get all the issuelists for the project.
     */
    public function issues()
    {
        return $this->hasManyThrough('App\Issue', 'App\IssueList');
    }

    /**
     * @return
     */
    public function memberStatus()
    {
        return $this->hasMany(MemberStatus::class, 'project_id');
    }

    // add part of notifications

}
