# frozen_string_literal: true

module Projects
  class BaseMoveRelationsService < BaseService
    attr_reader :source_project
    def execute(source_project, remove_remaining_elements: true)
      return if source_project.blank?

      @source_project = source_project

      true
    end

    private

    # rubocop: disable CodeReuse/ActiveRecord
    def prepare_relation(relation, id_param = :id)
      if Gitlab::Database.postgresql?
        relation
      else
        relation.model.where("#{id_param}": relation.pluck(id_param))
      end
    end
    # rubocop: enable CodeReuse/ActiveRecord
  end
end
