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
    public $timestamps = false;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'issue_list';

    /**
     * @var array
     */
    protected $fillable = ['name', 'project_id'];

    /**
     * @return
     */
    public function project()
    {
        return $this->belongsTo(Project::class, 'project_id');
    }

    /**
     * @return
     */
    public function issues()
    {
        return $this->hasMany(Issue::class, 'issue_list_id');
    }
}
