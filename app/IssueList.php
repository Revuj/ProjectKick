<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * ID
 * name NN
 * id_project -> project NN
 */
class IssueList extends Model
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
    protected $fillable = [ 'name', 'id_project' ]; 

    /**
     * @return 
     */
    public function issueList()
    {
        return $this->belongsTo(Project::class, 'id_project');
    }

    /**
     * @return 
     */
    public function issues()
    {
        return $this->hasMany(Issue::class,'issue_list_id');
    }
}
