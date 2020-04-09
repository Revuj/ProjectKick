<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * id
 * name
 * description
 * creation_date
 * due_date
 * is_completed
 * closed_date
 * issue_list_id
 * author_id
 * complete_id
 */
class Issue extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps  = false;
    
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'issue';

    /**
     * @var array
     */
    protected $protected = [ 'id', 'creation_date' ]; 

    /**
     * @return 
     */
    public function issueList()
    {
        return $this->belongsTo(IssueList::class, 'issue_list_id');
    }

    public function author() {
        return $this->belongsTo(User::class, 'author_id');
    }

    public function completed() {
        return $this->belongsTo(User::class, 'completed_id');
    }

    public function tags() {
        return $this->belongsToMany(Tag::class, 'issue_tag', 'issue_id', 'tag_id');
    }

    public function assignTo() {
        return $this->belongsToMany(User::class, 'assigned_user', 'user_id', 'issue_id');
    }

    public function comments() {
        return $this->hasMany(Comment::class, 'issue_id');
    }

    // falta assign Notification
}
