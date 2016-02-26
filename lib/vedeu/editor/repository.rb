# frozen_string_literal: true

module Vedeu

  module Editor

    # Allows the storing of documents.
    #
    class Repository < Vedeu::Repositories::Repository

      singleton_class.send(:alias_method, :documents, :repository)

      real Vedeu::Editor::Document
      null Vedeu::Editor::Document

    end # Repository

  end # Editor

  # Manipulate the repository of documents.
  #
  # @example
  #   Vedeu.documents
  #
  # @api public
  # @!method documents
  # @return [Vedeu::Editor::Repository]
  def_delegators Vedeu::Editor::Repository,
                 :documents

end # Vedeu
